---
tags: [azure, apim, app-service, access-restrictions, networking, diagnostico]
date: 2026-07-08
cluster/resource: stp-dig-apim-aiagentsapp-prd / stp-dig-app-aiagentsapp-prd (RG stp-dig-rg-aiagentsapp-prd, sub DIGITAL-PROD)
status: diagnosticado
---

## Contexto

Todas as chamadas via APIM `stp-dig-apim-aiagentsapp-prd` (custom domain `ianoapp.semparar.com.br`, path
`aiagents-prd`) passaram a retornar **403 "IP Forbidden"**. O usuário confirmou que o 403 não vinha da
aplicação (Web App) em si, sugerindo bloqueio em algum ponto entre o APIM e o backend.

## Diagnóstico

### Topologia confirmada
- APIM: `stp-dig-apim-aiagentsapp-prd`, RG `stp-dig-rg-aiagentsapp-prd`, sub `DIGITAL-PROD`
  (`b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058`). SKU Developer, VNet type **External**, injetado na subnet
  `stp-dig-snet-web-prd` (10.17.205.0/27) da vnet `stp-dig-vnet-prd` (RG `stp-dig-rg-net-prd`).
  Public IP do gateway: `20.197.209.247`.
- API `stp-dig-app-aiagentsapp-prd` (path `aiagents-prd`) usa o backend nomeado
  `WebApp_stp-dig-app-aiagentsapp-prd` -> `https://stp-dig-app-aiagentsapp-prd.azurewebsites.net`.
  Operations com `urlTemplate: /*` para todos os métodos — sem o bug de barra dupla já visto em
  outras APIs deste padrão (ver nota relacionada sobre urlTemplate).
- Web App `stp-dig-app-aiagentsapp-prd`: `publicNetworkAccess: Enabled`, VNet integration **outbound**
  apontando para `stp-dig-snet-app-prd` (subnet distinta, delegada a `Microsoft.Web/serverFarms`).
  Sem Private Endpoint.

### A causa raiz — Access Restriction zerada
`az webapp config access-restriction show` no site principal revelou:
```json
{
  "ipSecurityRestrictions": [
    {"action": "Deny", "ipAddress": "Any", "name": "Deny all", "priority": 2147483647}
  ],
  "ipSecurityRestrictionsDefaultAction": "Deny"
}
```
Ou seja: **zero regras Allow** no site de produção. Todo o tráfego, incluindo o do APIM, é rejeitado
pela camada de plataforma do App Service — antes de a requisição chegar ao container/aplicação. Isso
explica por que o 403 "IP Forbidden" não é gerado pela app.

Em contraste, `scmIpSecurityRestrictions` (Kudu/SCM) mantinha ~15 regras Allow com IPs corporativos
íntegras — só o site principal foi zerado. Esse padrão assimétrico é uma assinatura clássica de drift
no provider `azurerm`: o bloco `site_config.ip_restriction` é autoritativo; se não é declarado (ou é
declarado vazio) numa aplicação de Terraform/deploy, ele remove qualquer regra existente, enquanto
`scm_ip_restriction` (bloco separado) permanece intocado.

### Descartados
- **NSG** (`stp-dig-nsg-prd`, associado à subnet do APIM): só regras de plataforma padrão
  (AllowHttpsAPIManagement 443/VirtualNetwork, AllowAPIManagementEndpoint 3443/ApiManagement,
  AllowOutboundAccess, AllowAzureInfrastructureLoadBalancer). Um bloqueio de NSG geraria timeout/reset,
  não um 403 HTTP com corpo "IP Forbidden" — descartado.
- **Front Door / Application Gateway**: nenhum recurso encontrado na subscription `DIGITAL-PROD` na
  frente deste domínio — descartado.
- **Bug de urlTemplate** (double slash, visto em outra API do mesmo padrão): não se aplica aqui, todas
  as operations usam `/*` corretamente.

### Evidência temporal (Activity Log) — gatilho provável
```
2026-07-07T19:03:19Z  felipe.goncalves@corpay.com.br   config/appsettings, config/slotConfigNames
2026-07-07T20:03:50Z  SP GITHUB-ACTIONS (appId e99bb943-524c-45f5-a8ad-c8557884cad3)  config/appsettings
2026-07-07T20:04:23Z  SP GITHUB-ACTIONS                                              config/web  <- aqui fica ipSecurityRestrictions
2026-07-07T20:08:21Z  SP GITHUB-ACTIONS                                              config/web
```
Um dia antes do reporte, um pipeline GitHub Actions (SP `GITHUB-ACTIONS`) escreveu duas vezes em
`config/web` — recurso onde vive `siteConfig.ipSecurityRestrictions`. É a explicação mais provável do
drift: o deploy reescreveu `site_config` sem preservar a regra que permitia o APIM.

### IaC
Nenhum repositório Terraform local encontrado referenciando `aiagentsapp` (find/glob vazios — mesmo
padrão já visto no ambiente irmão `aihub-nprd`). O IaC/pipeline real vive em um repositório GitHub
Actions remoto (dono do SP acima), não clonado nesta máquina.

## Resolução

Ainda não aplicada (agente operou em modo read-only). Proposta:

1. Adicionar regra Allow no site principal baseada em VNet/subnet do APIM (preferível a IP fixo, pois
   a subnet `stp-dig-snet-web-prd` já tem Service Endpoint `Microsoft.Web` habilitado):
   ```
   az webapp config access-restriction add \
     --resource-group stp-dig-rg-aiagentsapp-prd \
     --name stp-dig-app-aiagentsapp-prd \
     --rule-name "Allow-APIM-VNet-aiagentsapp-prd" \
     --priority 100 \
     --action Allow \
     --vnet-name stp-dig-vnet-prd \
     --subnet stp-dig-snet-web-prd
   ```
   Alternativa mais simples porém menos robusta: allow por IP público do APIM (`20.197.209.247/32`) —
   funciona hoje (backend público, sem Private Endpoint), mas acopla a regra a um IP que muda se o
   APIM mudar de SKU/região.
2. Corrigir na fonte: localizar no repositório do pipeline GitHub Actions (`appId
   e99bb943-524c-45f5-a8ad-c8557884cad3`) por que o bloco `ip_restriction`/`site_config` do site
   principal não preserva essa regra, para não regredir no próximo apply.

## Comandos relevantes

```bash
# Localizar o APIM
az apim list --subscription b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058 --output table

# Detalhes de rede do APIM (VNet External mode, subnet, IP público)
az apim show --name stp-dig-apim-aiagentsapp-prd --resource-group stp-dig-rg-aiagentsapp-prd \
  --query "{publicIpAddresses:publicIpAddresses, vnetConfig:virtualNetworkConfiguration, vnetType:virtualNetworkType}"

# APIs e backend
az apim api list --service-name stp-dig-apim-aiagentsapp-prd --resource-group stp-dig-rg-aiagentsapp-prd --output table
az rest --method get --url "https://management.azure.com/subscriptions/<sub>/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.ApiManagement/service/stp-dig-apim-aiagentsapp-prd/backends?api-version=2022-08-01"

# Access Restrictions do Web App (o achado central)
az webapp config access-restriction show --name stp-dig-app-aiagentsapp-prd --resource-group stp-dig-rg-aiagentsapp-prd

# NSG da subnet do APIM
az network nsg rule list --resource-group stp-dig-rg-net-prd --nsg-name stp-dig-nsg-prd --output table

# Activity log para achar o gatilho da mudança
az monitor activity-log list --resource-group stp-dig-rg-aiagentsapp-prd --offset 30d \
  --query "[?contains(resourceId,'stp-dig-app-aiagentsapp-prd') && operationName.value=='Microsoft.Web/sites/config/write']"

# Identificar o caller (service principal)
az ad sp show --id <object-id-do-caller> --query "{displayName:displayName, appId:appId}"
```

## Lições aprendidas

- Um 403 "IP Forbidden" em App Service é gerado pela **camada de plataforma** (front-end), antes do
  container da aplicação — por isso "não vem da app" é um sinal correto e direto para checar
  `az webapp config access-restriction show`, não os logs da aplicação.
- Quando `ipSecurityRestrictions` (site principal) está zerado mas `scmIpSecurityRestrictions` está
  íntegro, é quase sempre drift de IaC: os dois blocos (`site_config.ip_restriction` vs
  `site_config.scm_ip_restriction` no provider `azurerm`) são geridos separadamente e um apply que
  omite/zera um não necessariamente afeta o outro.
- Para APIM em VNet External mode, o gateway tem IP público, mas o tráfego para backends dentro da
  mesma VNet passa pela subnet injetada — logo a restrição de Access Restriction do backend deve
  preferir uma regra por **subnet/Service Endpoint**, não por IP público fixo (mais resiliente a
  mudança de SKU/topologia do APIM).
- Cruzar `az monitor activity-log list` filtrando por `operationName.value=='Microsoft.Web/sites/config/write'`
  é o caminho mais rápido para achar "quem mexeu e quando" num Web App, e frequentemente aponta
  direto para o pipeline/CI responsável pelo drift.
- Repositório Terraform para este ambiente (`aiagentsapp-prd`, e também `aihub-nprd` em investigação
  anterior) não está clonado nesta máquina — o pipeline roda via GitHub Actions (SP `GITHUB-ACTIONS`,
  appId `e99bb943-524c-45f5-a8ad-c8557884cad3`). Vale mapear e documentar o repo real numa próxima
  sessão para permitir diff direto contra o HCL.

## Referências

- [[APIM AIHub - 404 em operacao por urlTemplate com barra dupla]] (nota irmã sobre outro padrão de
  misconfig neste tipo de API)
- Azure Well-Architected Framework — pilares Reliability, Security, Operational Excellence
