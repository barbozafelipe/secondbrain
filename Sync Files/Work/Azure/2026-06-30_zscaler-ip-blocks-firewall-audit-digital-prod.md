---
tags: [azure, storage-account, cognitive-services, openai, firewall, zscaler, diagnóstico, security]
date: 2026-06-30
subscription: DIGITAL-PROD (b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058)
status: entregue
---

# Auditoria de Blocos Zscaler — DIGITAL-PROD

## Contexto

Com a mudança dos blocos Zscaler para ranges mais amplos, vários recursos Azure da subscription DIGITAL-PROD permaneceram com os blocos /23 antigos. Colaboradores conectados via VPN/escritório usando IPs fora dos /23 antigos podem ter o acesso bloqueado.

**Blocos Zscaler NOVOS/CORRETOS:**
- `165.225.192.0/18`
- `136.226.0.0/16`
- `147.161.128.0/17`
- `170.85.0.0/16`

**Blocos Zscaler ANTIGOS encontrados (todos /23):**
- `147.161.128.0/23` — subconjunto de `147.161.128.0/17`
- `165.225.214.0/23` — subconjunto de `165.225.192.0/18`
- `136.226.62.0/23` — subconjunto de `136.226.0.0/16`
- `136.226.140.0/23` — subconjunto de `136.226.0.0/16`
- `136.226.138.0/23` — subconjunto de `136.226.0.0/16`

## Diagnóstico

### Recursos com blocos antigos e defaultAction: Deny (CRITICO)

| Recurso | Tipo | RG |
|---|---|---|
| `stpdigblogagentprd` | Storage Account | stp-dig-rg-blogagent-prd |
| `stp-dig-cog-chatbot-prd` | Cognitive Services/OpenAI | stp-dig-rg-chatbot-prd |

### Recursos com blocos antigos e defaultAction: Allow (media prioridade)

| Recurso | Tipo | RG | Obs |
|---|---|---|---|
| `stpdigaiagentsprd` | Storage Account | stp-dig-rg-aiagentsapp-prd | + VNet rule |
| `stpdigmcpserverprd` | Storage Account | stp-dig-rg-aihub-prd | + VNet rule |
| `stpdigstchatbotprd` | Storage Account | stp-dig-rg-chatbot-prd | + VNet rule |
| `stpdigstcopilotoprd` | Storage Account | stp-dig-rg-copilot-prd | Sem VNet rule |

### Recursos ja atualizados

| Recurso | Tipo | RG |
|---|---|---|
| `stp-dig-cog-copilot-prd` | OpenAI | stp-dig-rg-copilot-prd |

### Recursos sem restricoes IP ativas (N/A para esta auditoria)

- Key Vault `stp-dig-kv-aiagentsprd`: networkAcls null
- OpenAI: `stp-dig-oai-1-prd`, `stp-dig-cog-automacaovendas-prd`, `stp-dig-cog-blogagent-prd`, `stp-dig-cog-aiagentapp-prd` — abertos ou sem regras
- AIServices: `stp-dig-cog-ailoomi-prd` — Allow default
- App Services: `stp-dig-app-aiagentsdash-prd` (Allow all), `stp-dig-app-aiagentsapp-prd` (Deny via VNet), `stp-dig-app-copilot-prd` (Deny via VNet)
- Function Apps: `stp-dig-func-blogagent-prd` (Allow all), `stp-dig-func-mcpserver-prd` (Allow all), `stp-dig-func-chatbot-prd` (Deny via VNet), `stp-dig-func-copilot-prd` (Deny via VNet)
- APIM x3: External VNet, sem networkAcls — filtro de IP via policies (requer auditoria separada via portal ou `az apim policy show`)

## Resolucao

Para cada recurso com blocos antigos, substituir os /23 pelos 4 blocos novos. Manter VNet rules intactas.

**Sequencia recomendada:**
1. Adicionar os 4 novos blocos
2. Verificar conectividade
3. Remover os /23 antigos

## Comandos relevantes

```bash
# Auditoria — Storage Accounts
az storage account list --subscription "b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058" \
  --query "[].{name:name, rg:resourceGroup, networkRuleSet:networkRuleSet}" -o json

# Auditoria — Cognitive Services
az cognitiveservices account list --subscription "b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058" \
  --query "[].{name:name, rg:resourceGroup, kind:kind, networkAcls:properties.networkAcls}" -o json

# Adicionar novo bloco Zscaler em Storage Account (WRITE — requer confirmacao)
az storage account network-rule add \
  --resource-group <RG> \
  --account-name <STORAGE_NAME> \
  --ip-address "165.225.192.0/18"

# Remover bloco antigo de Storage Account (WRITE — requer confirmacao)
az storage account network-rule remove \
  --resource-group <RG> \
  --account-name <STORAGE_NAME> \
  --ip-address "165.225.214.0/23"

# Adicionar novo bloco em Cognitive Services (WRITE — requer confirmacao)
az cognitiveservices account network-rule add \
  --resource-group <RG> \
  --name <COG_NAME> \
  --ip-address "165.225.192.0/18"

# Remover bloco antigo de Cognitive Services (WRITE — requer confirmacao)
az cognitiveservices account network-rule remove \
  --resource-group <RG> \
  --name <COG_NAME> \
  --ip-address "147.161.128.0/23"
```

## Licoes aprendidas

- O recurso `stp-dig-cog-copilot-prd` ja esta com os 4 blocos novos — usar como referencia ao configurar os demais.
- Storage Accounts com `defaultAction: Allow` nao bloqueiam agora, mas devem ser corrigidos para consistencia e caso o default mude.
- APIM nao expoe IP filtering via networkAcls — filtros estao nas policies XML. Requer auditoria separada.
- `stpdigstcopilotoprd` e o unico Storage Account sem VNet rule — anomalia a observar.

## Referencias

- [Azure Storage Account network rules](https://learn.microsoft.com/azure/storage/common/storage-network-security)
- [Azure Cognitive Services network rules](https://learn.microsoft.com/azure/ai-services/cognitive-services-virtual-networks)
- [APIM IP filter policy](https://learn.microsoft.com/azure/api-management/ip-filter-policy)
