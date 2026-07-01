## Contexto

Investigação para localizar 4 certificados a renovar, citados pelo time como estando na "AWS Certificate Manager", mas que na prática estavam distribuídos entre AWS e Azure. A confusão veio de uma tabela colada com formatação quebrada, que fez o domínio real `ianoapp.semparar.com.br` parecer `app.semparar.com.br`.

## Resultado

| Domínio | Onde está | Conta/Subscription | Recurso | Expira em |
|---|---|---|---|---|
| `venda-segura.apisemparar.com.br` | AWS — ACM + CloudFront (`EILMW91YCU5UK`) | 867102406853 (STP PRD) | ACM `arn:aws:acm:us-east-1:867102406853:certificate/a7461947-0cd4-4da7-b104-1af42eb413d4` | 2026-07-28 |
| `ianoapp.semparar.com.br` | Azure — API Management | `stp-dig-rg-aiagentsapp-prd` / DIGITAL-PROD | APIM `stp-dig-apim-aiagentsapp-prd` | 2026-07-28 |
| `ianoapp-dev.semparar.com.br` | Azure — App Service | `stp-dig-rg-aiagentsapp-nprd` / DIGITAL-NPROD | App Service `stp-dig-app-aiagentsapp-nprd` | 2026-07-28 |
| `ianoapp-hml.semparar.com.br` | Azure — App Service (atrás de Private Endpoint) | `stp-dig-rg-aiagentsapp-hml-nprd` / DIGITAL-NPROD | App Service `stp-dig-app-aiagentsapp-hml-nprd` | 2026-07-28 |

Os 3 domínios `ianoapp*` usam o mesmo certificado SAN (thumbprint `22F776A8F8668DDF57AE7089B656E5481B8B5869`), sem auto-renovação configurada — renovação precisa ser feita manualmente nos três recursos.

## Como descobri onde cada um estava

- Tinha acesso a apenas uma conta AWS local (`BR_PS_CLOUD-867102406853`). O usuário levantou a lista completa de ~36 contas da org Corpay/Fleetcor e priorizamos 7 candidatas pelo nome (Fintech, Vendas, Centro de Gestão de Meios de Pagamento SA) para varrer ACM via `aws acm list-certificates` nas regiões `sa-east-1`/`us-east-1`.
- `venda-segura.apisemparar.com.br` apareceu na conta STP PRD (867102406853), anexado a uma distribuição CloudFront.
- Os domínios `ianoapp*` não apareceram em nenhuma das 7 contas AWS — o passo decisivo foi rodar `nslookup` nos domínios, que revelou CNAME para `*.azure-api.net` (Azure API Management), confirmando que não eram recursos AWS.
- A partir daí, o agente Azure localizou os 3 recursos e o certificado compartilhado.

## Validação pós-renovação

Comando rápido para checar a data de expiração que está sendo servida de fato (não depende de qual cloud está por trás):

```bash
openssl s_client -connect <dominio>:443 -servername <dominio> </dev/null 2>/dev/null | openssl x509 -noout -enddate
```

Para `ianoapp-hml.semparar.com.br`, é preciso estar na rede corporativa/VPN (recurso atrás de Private Endpoint, não resolve externamente).

## Notas relacionadas

- [[[Azure] Localizar certificado ianoapp (diagnóstico)]]
- [[[Azure] Trocar certificado ianoapp pelo portal (procedimento)]]
