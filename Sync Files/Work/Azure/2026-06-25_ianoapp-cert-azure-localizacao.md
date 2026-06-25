---
tags: [azure, api-management, app-service, certificado-tls, diagnostico]
date: 2026-06-25
cluster/resource: stp-dig-apim-aiagentsapp-prd, stp-dig-app-aiagentsapp-nprd, stp-dig-app-aiagentsapp-hml-nprd
status: resolvido
---

## Contexto

Investigação de certificados TLS para domínios SemParar/Corpay que precisam renovação. Três domínios (`ianoapp.semparar.com.br`, `ianoapp-dev.semparar.com.br`, `ianoapp-hml.semparar.com.br`) inicialmente pensados como AWS, mas a resolução DNS indicava Azure (CNAME chain via Traffic Manager + `azure-api.net` para o primeiro; IP privado para o segundo; NXDOMAIN para o terceiro). Objetivo: localizar os recursos Azure reais e os certificados associados, sem nenhuma ação de escrita.

## Diagnóstico

Tenant SEM PARAR (`e710eef2-4915-4eba-8fbe-5fd8583a44f8`), múltiplas subscriptions. Recursos encontrados:

- **`ianoapp.semparar.com.br`** -> Azure API Management `stp-dig-apim-aiagentsapp-prd`, RG `stp-dig-rg-aiagentsapp-prd`, subscription **DIGITAL-PROD** (`b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058`), região Brazil South, SKU Developer. Custom domain configurado em `hostnameConfigurations`, `certificateSource: Custom` (importado direto, **sem** `keyVaultId` — não é Key Vault-managed, não tem auto-renovação).

- **`ianoapp-dev.semparar.com.br`** -> Azure App Service `stp-dig-app-aiagentsapp-nprd`, RG `stp-dig-rg-aiagentsapp-nprd`, subscription **DIGITAL-NPROD** (`36df8ac5-dab6-4301-9cbf-97aa398ba021`). Sem Private Endpoint — acesso público com IP allowlist (`ipSecurityRestrictionsDefaultAction: Deny` + lista de ranges permitidos). O IP `10.17.204.133` relatado no nslookup do usuário não bate exatamente com nenhum recurso identificado via `az` (subnet de private endpoints `stp-dig-snet-pep-nprd` tem outro IP, `.135`, associado ao ambiente hml) — ponto não confirmado 100%, possivelmente DNS interno on-prem ou outro proxy fora do escopo Azure puro.

- **`ianoapp-hml.semparar.com.br`** -> Azure App Service `stp-dig-app-aiagentsapp-hml-nprd`, RG `stp-dig-rg-aiagentsapp-hml-nprd`, subscription DIGITAL-NPROD, com Private Endpoint (`stp-dig-pep-app-hml-nprd`, IP `10.17.204.135`, subnet `stp-dig-snet-pep-nprd`, VNet `stp-dig-vnet-nprd`). Resource existe e está com binding TLS ativo; o NXDOMAIN no nslookup do usuário é provavelmente falta de visibilidade da zona DNS privada/pública dali, não ausência do recurso.

**Certificado:** os três pontos usam o **mesmo certificado SAN**, mesmo thumbprint `22F776A8F8668DDF57AE7089B656E5481B8B5869`, CN=`ianoapp.semparar.com.br`, SANs incluindo `ianoapp-dev` e `ianoapp-hml`, emitido por DigiCert Global G2 TLS RSA SHA256 2020 CA1. Issue date 2025-07-29, **expiry 2026-07-28T23:59:59Z**. Replicado manualmente em 3 recursos:
  - APIM prod: certificado custom (sem Key Vault)
  - App Service dev: `Microsoft.Web/certificates/ianoapp.semparar.com.br-2025`
  - App Service hml: `Microsoft.Web/certificates/ianoapp-hml.semparar.com.br-2025`

Nenhum dos três tem Key Vault binding ou managed certificate da Microsoft — renovação 100% manual nos três lugares.

## Resolução

Diagnóstico de localização concluído — não houve ação de remediação nesta sessão (certificado ainda válido até 2026-07-28, fora da janela de renovação imediata). Próximos passos definidos: confirmar lead-time de emissão com a CA, e avaliar migração para Key Vault-backed certs antes do vencimento.

## Comandos relevantes

```bash
# Localizar o APIM
az apim list --subscription <sub> --query "[?contains(name,'aiagentsapp')]"

# Detalhes de custom domain + certificado no APIM
az apim show --name stp-dig-apim-aiagentsapp-prd --resource-group stp-dig-rg-aiagentsapp-prd --subscription b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058

# Localizar App Service Certificates (dev e hml)
az resource show --subscription 36df8ac5-dab6-4301-9cbf-97aa398ba021 --resource-group stp-dig-rg-aiagentsapp-nprd --name "ianoapp.semparar.com.br-2025" --resource-type Microsoft.Web/certificates
az resource show --subscription 36df8ac5-dab6-4301-9cbf-97aa398ba021 --resource-group stp-dig-rg-aiagentsapp-hml-nprd --name "ianoapp-hml.semparar.com.br-2025" --resource-type Microsoft.Web/certificates

# Hostname bindings / SSL state nos App Services
az webapp show --subscription <sub> --resource-group <rg> --name <app> --query "hostNameSslStates"

# Private endpoint do ambiente hml
az network private-endpoint show --subscription <sub> --resource-group stp-dig-rg-aiagentsapp-hml-nprd --name stp-dig-pep-app-hml-nprd
```

## Lições aprendidas

- DNS chain com Traffic Manager + `*.azure-api.net` é assinatura forte de Azure API Management — vale checar `az apim list` direto antes de assumir AWS.
- Domínios "dev"/"hml" de um mesmo projeto SemParar/Corpay frequentemente vivem em RGs separados dentro da subscription NPROD (`<rg>-nprd` e `<rg>-hml-nprd`), nunca dentro do RG PROD.
- Um certificado SAN único cobrindo prod+dev+hml é um anti-padrão de Reliability/Security: ponto único de expiração simultânea em múltiplos ambientes, sem Key Vault, sem auto-renovação.
- NXDOMAIN em nslookup não significa "recurso não existe" — pode ser apenas zona DNS não visível da rede de onde a consulta foi feita (especialmente quando o recurso usa Private Endpoint).

## Referências

- Subscription DIGITAL-PROD: `b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058`
- Subscription DIGITAL-NPROD: `36df8ac5-dab6-4301-9cbf-97aa398ba021`
- Tenant SEM PARAR: `e710eef2-4915-4eba-8fbe-5fd8583a44f8`
- Certificado AWS ACM relacionado (já resolvido, fora do escopo Azure): `venda-segura.apisemparar.com.br`, conta AWS 867102406853, válido até 2026-07-28
