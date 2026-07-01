# Diagnóstico K8s — Domínio *.prd.okewlg.corpay.com.br não encontrado nos clusters
Data: 2026-06-19
Cluster: todos (oke-dr, oke-vb, rke-dr, rke-rsfn-nprd, rke-rsfn-prd, rkeapp, rkelab, rkenprd, rkeprd)
Namespace: N/A (busca global)

## Problema
Usuário procurava pelo domínio/wildcard `*.prd.okewlg.corpay.com.br` em Ingress, Secrets TLS, cert-manager Certificate/ClusterIssuer/Issuer e Gateway/VirtualService em todos os clusters Kubernetes gerenciados via Rancher, e não conseguiu localizar manualmente.

## Causa Raiz
O domínio não existe em nenhum recurso Kubernetes nos 9 clusters acessíveis. Encontrado domínio textualmente muito similar em `oke-vb` (e replicado em `rke-dr`): wildcard `*.prd.oke.fleetcor.com.br` (SAN idêntico), usado nos secrets `ingress-nginx-internal/default-ssl-certificate{,-1,-2,-3,-4}`, `haproxy-internal/default-ssl-certificate` e `vb-emissores-prd/default-ssl-certificate-1` (oke-vb), e `vb-api-prd/default-ssl-certificate-4` (rke-dr).

Hipótese mais provável: confusão de nomenclatura entre `oke` (sufixo real do cluster) e `okewlg` (possível mistura com sigla de projeto não identificada), e entre `corpay.com.br` (marca atual) e `fleetcor.com.br` (domínio legado ainda em uso nos certificados/CA interna).

cert-manager não está instalado em nenhum cluster (CRDs Certificate/ClusterIssuer/Issuer ausentes ou sem recursos) — certificados são geridos manualmente via Secret `kubernetes.io/tls`. Não há Istio em nenhum cluster; Gateway API (HTTPRoute/Gateway) existe como CRD em vários clusters RKE mas sem nenhum recurso criado, e nem como CRD em oke-dr/oke-vb.

## Comandos Utilizados
```bash
kubectl config get-contexts -o name
kubectl --context <ctx> get ingress -A -o json
kubectl --context <ctx> get secrets -A --field-selector type=kubernetes.io/tls
kubectl --context <ctx> get certificate.cert-manager.io -A
kubectl --context <ctx> get clusterissuer.cert-manager.io -A
kubectl --context <ctx> get issuer.cert-manager.io -A
kubectl --context <ctx> api-resources | grep -iE "virtualservice|gateway|httproute"
kubectl --context <ctx> get httproutes -A -o json
kubectl --context <ctx> get gateways -A -o json
kubectl --context oke-vb get secret default-ssl-certificate -n ingress-nginx-internal -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -subject -ext subjectAltName
```

## Resolução
Não há remediação a aplicar no cluster — o domínio simplesmente não existe no estado atual. Próximos passos recomendados:
1. Confirmar resolução DNS de `*.prd.okewlg.corpay.com.br` (dig/nslookup) para descobrir se é gerenciado fora do K8s (LB externo, F5 BIG-IP, CDN) ou se é erro de digitação.
2. Validar com o time de DNS/Rede e com o Thiago (projeto de rotação de certs TLS) se "okewlg" é codinome de cluster/ambiente novo ainda não integrado ao kubeconfig/Rancher.
3. Se confirmado erro de digitação, o domínio correto em produção OKE é `*.prd.oke.fleetcor.com.br` (cluster oke-vb).
