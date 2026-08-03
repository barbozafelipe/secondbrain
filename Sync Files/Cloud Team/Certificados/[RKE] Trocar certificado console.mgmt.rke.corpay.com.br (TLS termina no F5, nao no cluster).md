---
tags: [rke, rancher, haproxy, f5, certificado-tls, ssl-offload, procedimento, gotcha]
date: 2026-07-14
cluster/resource: rke-cluster-mgmt (console.mgmt.rke.corpay.com.br), F5 produção VS 10.0.173.192
status: resolvido
---

## Trocar o certificado do console do Rancher de management

> [!warning] A pegadinha (leia isto primeiro)
> O certificado que o navegador vê em `https://console.mgmt.rke.corpay.com.br/` **NÃO é servido pelo cluster** — o TLS é **terminado num Virtual Server do F5 de produção** (VIP `10.0.173.192`), que faz SSL offload e repassa pro HAProxy do cluster. **Trocar o cert no Kubernetes/Flux não muda nada do que o cliente enxerga.** O cert tem que ser trocado **no F5**.
>
> Provável que **outros serviços internos estejam no mesmo esquema** (F5 fazendo offload com o cert replicado). Sempre verifique onde o TLS realmente termina antes de mexer só no cluster.

### Como o tráfego realmente flui

```
navegador → https://console.mgmt.rke.corpay.com.br
            → DNS resolve para 10.0.173.192  (NÃO é node do cluster; nodes são 10.0.106.x)
            → F5 (VS de produção) TERMINA o TLS aqui, com o cert do clientssl profile  ← é AQUI que se troca
            → repassa para o HAProxy ingress do cluster (NodePort 31376)
```

### Como diagnosticar onde o TLS termina (método que resolveu)

A prova é comparar o cert servido no VIP com o que o HAProxy do cluster realmente carrega:

1. Cert que o cliente vê (o do F5):
   ```bash
   echo | openssl s_client -connect 10.0.173.192:443 -servername console.mgmt.rke.corpay.com.br 2>/dev/null \
     | openssl x509 -noout -fingerprint -sha256 -enddate
   ```
2. Cert que o HAProxy do cluster carrega (runtime API, dentro do pod em ns `haproxy`):
   ```bash
   kubectl --context rke-mgmt -n haproxy exec <pod-haproxy> -c kubernetes-ingress-controller -- \
     sh -c 'echo "show ssl cert" | socat stdio /var/run/haproxy-runtime-api.sock'
   ```
3. **Se o fingerprint do VIP ≠ do HAProxy → o TLS termina antes do cluster (F5).** Se o VIP faz passthrough puro, os dois fingerprints seriam iguais. No nosso caso o VIP servia o cert antigo enquanto o HAProxy já servia o novo → F5 terminando confirmado.

Confirmar também que o DNS não aponta pro cluster: `nslookup console.mgmt.rke.corpay.com.br` → `10.0.173.192` (fora do range dos nodes `10.0.106.x`).

### O fix de verdade: F5

No Virtual Server que atende `10.0.173.192:443`, o **Client SSL profile** tinha o cert `*.mgmt.rke.corpay.com.br_2025` (Partition `Common`).

1. Importar o cert novo no F5 (System → Certificate Management). Se vier `.pfx`, importar cert+chave de uma vez (pede a senha do pfx).
2. Apontar o clientssl profile do VS para o cert novo.
3. Aplicar. Testar com o `openssl s_client` do passo 1 — o `notAfter`/fingerprint tem que virar o novo.

Quem tem acesso ao F5 de produção: **Thiago Ribeiro da Silva** (foi ele quem importou nesta ocasião).

### As mudanças no cluster (secundárias, mas mantidas por correção)

Feitas via GitOps no repo `k8s-mgmt` (Flux, não ArgoCD). Deixam o cert interno do cluster consistente com o novo, mas **sozinhas não resolvem o que o cliente vê** por causa do offload no F5:

- `clusters/rke-cluster-mgmt/kubespray/manifests/cluster/helmrelease-haproxy-ingress.yaml` → `controller.defaultTLSSecret.secret` = cert novo (é o `--default-ssl-certificate` do pod).
- `clusters/rke-cluster-mgmt/kubespray/manifests/cluster/helmrelease-rancher.yaml` → `ingress.tls.secretName` = cert novo.
- O secret precisa existir nos namespaces certos: `haproxy` (default do controller) **e** `cattle-system` (referenciado pelo ingress do Rancher). Se faltar em `cattle-system`, o ingress cai no cert default.
- Detalhe de SNI: como os dois certs (antigo e novo) têm `console.mgmt...` + `*.mgmt...` no SAN, o cert *default* do HAProxy (prefixo `0_`) sombreia o do ingress — por isso o que importa no cluster é o `defaultTLSSecret`.
- Forçar reconcile sem o flux CLI:
  ```bash
  kubectl --context rke-mgmt -n flux-system annotate gitrepository cluster reconcile.fluxcd.io/requestedAt="$(date +%s)" --overwrite
  kubectl --context rke-mgmt -n flux-system annotate helmrelease haproxy-ingress reconcile.fluxcd.io/requestedAt="$(date +%s)" --overwrite
  ```

### Dados do certificado (esta rotação)

| | Antigo (F5, `*.mgmt.rke.corpay.com.br_2025`) | Novo (`rke-mgmt-cert-fleetcor-v1-2031jun09`) |
|---|---|---|
| Fingerprint SHA-256 | `D6:22:70:C8:4D:DE:1F:08:…:C3:3D:85:A4` | `60:08:61:C6:A2:44:60:2F:…:B9:AE:92:CA` |
| Expira | 28/06/2027 | 09/06/2031 |
| SAN | `console.mgmt.rke.corpay.com.br`, `*.mgmt.rke.corpay.com.br` | idem |
| Issuer | FleetcorBR (CA interna) | idem |

### Relacionado

- [[Rotação de certificados]] — projeto guarda-chuva; todos os certs internos (CA antiga) expiram **28/06/2027**. Este é um deles. Escopo lista Rancher, Argo, Dragonfly, Keycloak, wildcard `*.prd.oke`, Kafka.
- [[Rancher]] · [[[AWS] Certificado no LoadBalancer]] (mesma ideia de cert num LB, na AWS)
