---
tags: [azure, function-app, access-restrictions, networking, zscaler, diagnostico, resolvido]
date: 2026-07-14
cluster/resource: stp-dig-func-copilot-nprd (RG stp-dig-rg-copilot-nprd, sub DIGITAL-NPROD)
status: resolvido
---

## Contexto

João (GO AI) reportou que chamadas via Postman para `stp-dig-func-copilot-nprd` (endpoint
`/api/microinsurance-offer`) retornavam **403 "IP Forbidden"** — response HTML `Web App - Unavailable`,
não um erro da aplicação. Pedido: liberar a regra de rede que bloqueia, para poder testar sem depender
do front (site do Free Flow / app que consome a func).

## Diagnóstico

`az webapp config access-restriction show -g stp-dig-rg-copilot-nprd -n stp-dig-func-copilot-nprd`
revelou o **mesmo padrão assimétrico** já visto em [[403 IP Forbidden no APIM aiagentsapp-prd por Access Restriction zerada no Web App]]:

- **`ipSecurityRestrictions`** (site principal, produção real do tráfego): só a regra
  `"Deny all" / ipAddress: Any / priority: 2147483647`. **Zero regras Allow.**
  `ipSecurityRestrictionsDefaultAction: Deny`.
- **`scmIpSecurityRestrictions`** (Kudu/SCM): ~15 regras Allow **íntegras**, incluindo os 4 blocos
  Zscaler "guarda-chuva" (ver [[Blocos de endereçamento IP (CIDR)]]):
  `147.161.128.0/17`, `170.85.0.0/16`, `136.226.0.0/16`, `165.225.192.0/18` — mais IPs específicos
  (VPNs/parceiros: `189.112.14.105/29`, `177.19.170.91/29`, `189.42.46.100/26`, `75.2.98.97/32`,
  `99.83.150.238/32`, `64.215.22.0/24`, `197.98.201.0/24`, `165.225.34.0/23`, `201.72.145.18/28`,
  `177.19.186.226/29`, `189.2.204.98/28`).

Ou seja: o site **principal** nega tudo (só passa por Private Endpoint), enquanto o **SCM** está
liberado normalmente. Confirma a suspeita "não vem da app" — é a camada de plataforma do App Service
barrando antes do container.

## Resolução aplicada

Adicionadas as **4 regras Allow "guarda-chuva"** (as que cobrem todos os ranges corporativos Zscaler,
conforme alinhado com Thiago Barros — ver [[Blocos de endereçamento IP (CIDR)]]) no site principal:

```bash
az account set --subscription 36df8ac5-dab6-4301-9cbf-97aa398ba021   # DIGITAL-NPROD

RG=stp-dig-rg-copilot-nprd
APP=stp-dig-func-copilot-nprd

az webapp config access-restriction add -g $RG -n $APP --rule-name "Allow-Zscaler-165.225.192.0-18" --priority 100 --action Allow --ip-address 165.225.192.0/18
az webapp config access-restriction add -g $RG -n $APP --rule-name "Allow-Zscaler-136.226.0.0-16"   --priority 101 --action Allow --ip-address 136.226.0.0/16
az webapp config access-restriction add -g $RG -n $APP --rule-name "Allow-Zscaler-147.161.128.0-17" --priority 102 --action Allow --ip-address 147.161.128.0/17
az webapp config access-restriction add -g $RG -n $APP --rule-name "Allow-Zscaler-170.85.0.0-16"    --priority 103 --action Allow --ip-address 170.85.0.0/16
```

Validado com `az webapp config access-restriction show` — as 4 regras entraram com prioridade
100-103 (avaliadas antes do "Deny all" em 2147483647). Resultado: qualquer máquina saindo pela rede
corporativa (Zscaler) passa a acessar o site principal — não só um IP individual — sem abrir a função
para a internet pública.

⚠️ **Não foi usada** a opção "Enabled from all networks" (limparia todas as restrições e exporia a
função publicamente) — a correção foi puramente aditiva.

## ⚠️ Risco de regressão (drift) — ainda não mitigado

Igual ao caso do `aiagentsapp-prd`: essas 4 regras foram adicionadas **via CLI/portal**, não via IaC.
Se essa função for gerida por pipeline/Terraform que declara `site_config.ip_restriction` sem incluir
essas regras, o próximo `apply`/deploy **vai zerá-las de novo** (é o mecanismo exato documentado na
nota irmã). Ação futura: localizar o repositório/pipeline responsável pelo `copilot-nprd` e persistir
essas 4 regras no código.

## Lições aprendidas (reforça o padrão já visto)

- Esse é o **segundo caso** do mesmo padrão de drift (`ipSecurityRestrictions` zerado vs
  `scmIpSecurityRestrictions` íntegro) em recursos distintos — vale tratar como padrão recorrente do
  ambiente, não incidente isolado. Ao investigar qualquer 403 "IP Forbidden" em Function/Web App neste
  tenant, checar `access-restriction show` primeiro.
- Os **4 blocos "guarda-chuva" do Zscaler** (`165.225.192.0/18`, `136.226.0.0/16`, `147.161.128.0/17`,
  `170.85.0.0/16`) são a forma padrão de liberar acesso de toda a rede corporativa de uma vez — cobrem
  os ranges específicos por cidade/site listados em [[Blocos de endereçamento IP (CIDR)]]. Usar esses
  4 como primeira tentativa em vez de liberar IP individual, quando o objetivo é "o time todo consegue
  testar".
- Comando de diagnóstico rápido: `az webapp config access-restriction show -g <rg> -n <app>` — compara
  `ipSecurityRestrictions` (site) vs `scmIpSecurityRestrictions` (Kudu) lado a lado.

## Referências

- [[403 IP Forbidden no APIM aiagentsapp-prd por Access Restriction zerada no Web App]] — caso irmão,
  mesmo padrão de causa raiz, análise mais profunda do porquê do drift (pipeline GitHub Actions).
- [[Blocos de endereçamento IP (CIDR)]] — lista completa dos ranges Zscaler e os 4 blocos guarda-chuva.
