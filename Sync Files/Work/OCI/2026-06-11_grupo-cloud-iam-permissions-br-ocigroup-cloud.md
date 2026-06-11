---
tags: [oci, iam, policy, grupo-cloud, diagnóstico]
date: 2026-06-11
cluster/resource: tenancy (root compartment) - fleetcorbr
status: resolvido
---

# Permissões do "grupo de cloud" — BR_OCIGROUP_CLOUD

## Contexto

Demanda do time de Cloud & Plataforma para identificar quais permissões o "grupo de cloud" possui na OCI da SemParar/Corpay. Não havia certeza do nome exato do grupo nem em qual Identity Domain ele estava.

## Diagnóstico

- O tenancy `fleetcorbr` (`ocid1.tenancy.oc1..aaaaaaaa4gqu63hhe4daunesiiblmagtq62zzv4cnqublhjvuroz57t5yaha`) possui 3 Identity Domains: `OracleIdentityCloudService`, `Default`, `Corpay`.
- `oci.cmd iam group list` (sem flags extras) só retorna grupos do domain **Default** (17 grupos, padrão `BR_OCI_*` / `BR_OKE_*`). Nenhum contém "CLOUD" no nome ali, exceto `CloudGuardUsers` (não relacionado ao time de cloud).
- O grupo correto é **`BR_OCIGROUP_CLOUD`**, no Identity Domain **Corpay** (federação Okta, `CreatedBy: okta/jaderson.valdivino@fleetcor.com.br`). Referenciado nas policies como `'Corpay'/'BR_OCIGROUP_CLOUD'`.
- Existe também uma variante `Ok_BR_OCIGROUP_CLOUD` com permissões idênticas — possível grupo de "aprovação/OK" de access request, sem limpeza dos statements antigos.
- Não foi possível enumerar o membership do grupo via `oci.cmd identity-domains groups list --endpoint <Corpay IDCS URL>` por erro de SSL (`SSLException: missing additional certificates for operation`) — limitação local de cert bundle, não de permissão. Necessário resolver via `REQUESTS_CA_BUNDLE`/`--cert-bundle` ou consultar via Console.

## Resolução

Diagnóstico entregue — policy `BR_OCIGROUP_CLOUD` (compartimento root/tenancy) concede:

- `manage all-resources in tenancy` — acesso ADMIN TOTAL (4 statements redundantes cobrindo `BR_OCIGROUP_CLOUD`, `Ok_BR_OCIGROUP_CLOUD`, com e sem prefixo `'Corpay'/`)
- `manage tickets in tenancy` (redundante, já coberto pelo all-resources)
- `manage buckets/objects in compartment FATURAS` (redundante, já coberto pelo all-resources)
- `Allow service objectstorage-sa-saopaulo-1 to manage object-family in compartment FATURAS` (statement de serviço, não do grupo)

## Comandos relevantes

```bash
# Listar identity domains do tenancy
oci.cmd iam domain list --compartment-id ocid1.tenancy.oc1..aaaaaaaa4gqu63hhe4daunesiiblmagtq62zzv4cnqublhjvuroz57t5yaha \
  --auth security_token --profile DEFAULT \
  --query "data[].{Name:\"display-name\", URL:\"url\", State:\"lifecycle-state\", OCID:id}" --output table

# Listar grupos (domain Default apenas)
oci.cmd iam group list --all --auth security_token --profile DEFAULT \
  --compartment-id ocid1.tenancy.oc1..aaaaaaaa4gqu63hhe4daunesiiblmagtq62zzv4cnqublhjvuroz57t5yaha --output table

# Listar policies do compartimento root e grep por CLOUD
oci.cmd iam policy list --all \
  --compartment-id ocid1.tenancy.oc1..aaaaaaaa4gqu63hhe4daunesiiblmagtq62zzv4cnqublhjvuroz57t5yaha \
  --auth security_token --profile DEFAULT \
  --query "data[].{Name:name, Statements:statements}" --output json

# Tentativa (falhou por SSL) de listar membros do grupo no domain Corpay
oci.cmd identity-domains groups list \
  --endpoint "https://idcs-f3d45ec0a91649d78931adc68f112a6c.identity.oraclecloud.com:443" \
  --auth security_token --profile DEFAULT \
  --filter 'displayName co "CLOUD"'
```

## Lições aprendidas

- `oci.cmd iam group list` sem parâmetros adicionais só enxerga o domain **Default** — em tenancies multi-domain (federação Okta via domain "Corpay"), grupos de negócio reais (prefixo `BR_OCIGROUP_*`) ficam fora dessa listagem.
- Para listar grupos/membros de domains não-Default, usar `oci.cmd identity-domains groups list --endpoint <IDCS URL do domain>` — porém nesta máquina há erro de SSL (cert bundle ausente) ao acessar endpoints IDCS diretamente. Resolver com `--cert-bundle` ou `REQUESTS_CA_BUNDLE` antes de tentar de novo.
- Policies que concedem `manage all-resources in tenancy` para grupos de cloud/plataforma são comuns neste tenancy (mesmo padrão em `BR_OCIGROUP_DBA`, `BR_OCIGROUP_SRE`, `BR_OCIGROUP_SERVIDORES`, `BR_OCIGROUP_PRODUCAO` parcialmente) — não é exclusividade do BR_OCIGROUP_CLOUD, é o padrão de governança adotado pela Compass UOL/Corpay neste ambiente.
- Statements duplicados/redundantes em policies (mesmo grant repetido com pequenas variações de nome de grupo) são recorrentes neste tenancy — sinal de edições incrementais sem consolidação. Vale revisão periódica de IAM policies para reduzir ruído de auditoria.

## Referências

- Policy: `BR_OCIGROUP_CLOUD` (compartimento root / tenancy `fleetcorbr`)
- Identity Domain: `Corpay` (`ocid1.domain.oc1..aaaaaaaayrlv6mloanumvqf4wbvumvifc4njhbqexzywbf3c7wzmhlfubo7q`)
- [[project_aihub_apim_nprd]] (memória relacionada a outros diagnósticos do tenancy)
