---
tags: [azure, api-management, app-service, certificado-tls, procedimento]
date: 2026-06-25
cluster/resource: stp-dig-apim-aiagentsapp-prd, stp-dig-app-aiagentsapp-nprd, stp-dig-app-aiagentsapp-hml-nprd
status: procedimento
---

## Troca do certificado TLS pelo portal Azure (ianoapp)

Mesmo cert SAN (`ianoapp.semparar.com.br` + SANs dev/hml) replicado em 3 recursos, sem Key Vault, sem auto-renovação. Tem que trocar nos 3, em 2 subscriptions. Ver localização em [[[Azure] Localizar certificado ianoapp (diagnóstico)]].

Pré-requisito: ter o novo `.pfx` (cert + chave privada + cadeia) e a senha.

### 1. APIM prod — `stp-dig-apim-aiagentsapp-prd` (sub DIGITAL-PROD)

1. Portal → API Management → `stp-dig-apim-aiagentsapp-prd`.
2. Menu **Custom domains** → clicar no domínio `ianoapp.semparar.com.br`.
3. Em **Certificate**: tipo *Custom* → **Upload** do novo `.pfx` → informar a senha.
4. Salvar. A propagação no APIM leva alguns minutos (não é instantânea).
5. Validar: `curl -vI https://ianoapp.semparar.com.br` e conferir a nova data de expiry.

### 2. App Service dev — `stp-dig-app-aiagentsapp-nprd` (sub DIGITAL-NPROD)

1. Portal → App Service → `stp-dig-app-aiagentsapp-nprd`.
2. **Certificates** → aba **Bring your own certificates (.pfx)** → **Add certificate** → upload do `.pfx` + senha.
3. Ir em **Custom domains** → no domínio, **Update binding** (ou Add binding) → selecionar o cert novo → tipo **SNI SSL**.
4. Validar binding em `hostNameSslStates` / `curl -vI` no domínio dev.
5. Depois de confirmar, remover o cert antigo (`ianoapp.semparar.com.br-2025`) para não deixar lixo.

### 3. App Service hml — `stp-dig-app-aiagentsapp-hml-nprd` (sub DIGITAL-NPROD)

Mesmos passos do item 2, no recurso hml. Cert antigo a remover: `ianoapp-hml.semparar.com.br-2025`. Atenção: hml tem Private Endpoint, então o teste de validação precisa ser feito de dentro da rede que enxerga a zona DNS privada.

### Notas

- Como é o mesmo `.pfx` nos 3, dá pra subir o mesmo arquivo em cada lugar.
- Ordem sugerida: dev → hml → prod (validar nos não-prod antes de mexer em prod).
- Pós-troca: avaliar migrar para cert Key Vault-backed para acabar com a renovação manual tripla.
