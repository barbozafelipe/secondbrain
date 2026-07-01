---
tags: [request, ritm, azure, blogagent, freeflow, setup-ambiente, prd, migracao, follow-up]
status: concluido
criado: 2026-06-23
solicitante: Joao Henrique Pfingstag Barth
origem: CHG0096757
task-execucao: TASK1255089
data-agendada: 2026-06-24
chamado: RITM0903921
---

# RITM0903921 — Recriar RG blogagent como `-prd` + excluir `-prod`

> [!info] Resumo de uma linha
> Follow-up da [[Setup PRD do Agente de Duvidas do Blog Free Flow]] (encerrada incompleta). Criar `stp-dig-rg-blogagent-prd` (com `-prd`) com os mesmos recursos/tiers do `stp-dig-rg-blogagent-prod` e, após validação, **excluir** o `-prod`. Corrige o mismatch de nome que travava a pipeline (`ResourceGroupNotFound`).

---

## 🧩 Contexto (por que existe)

A [[Setup PRD do Agente de Duvidas do Blog Free Flow]] subiu o stack no RG **`stp-dig-rg-blogagent-prod`** (com `-prod`, conforme o texto do chamado original), mas a esteira de deploy procura **`stp-dig-rg-blogagent-prd`** (com `-prd`) → `ResourceGroupNotFound`, falhando a task 4 e encerrando a change incompleta.

- Azure **não renomeia RG**. `az resource move` **não suporta** AI Search nem Redis Enterprise → solução é **recriar** via Terraform.
- Nada funcional crítico subiu no `-prod` → recriar é seguro.

---

## 📋 Dados do chamado

- **Solicitante:** Joao Henrique Pfingstag Barth · 53999277866
- **Item:** Azure · **Ação:** Configuração
- **Descrição resumida:** Criação do grupo de recursos `stp-dig-rg-blogagent-prd` e exclusão do grupo de recursos `stp-dig-rg-blogagent-prod`.
- **Descrição:** Para garantir a padronização de nomenclatura dos grupos de recursos e o funcionamento correto das pipelines, criar o RG `stp-dig-rg-blogagent-prd` com os mesmos recursos e tiers do `stp-dig-rg-blogagent-prod`. Após a criação, excluir o `stp-dig-rg-blogagent-prod`.
- **Subscription:** `b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058` (DIGITAL-PROD)

---

## ✅ Aprovações

| Grupo | Status |
|---|---|
| Cloud/k8s | ✅ Aprovado (Felipe Barboza Goncalves) |
| SRE | ✅ Aprovado |
| Arquitetura Sistemas | ✅ Aprovado |
| SN_REVISOR_Infraestrutura | ✅ Aprovado |

> Aprovado → task de execução **TASK1255089** (Cloud/k8s, atribuída a Felipe) aberta, agendada 24-06-2026.

---

## 🔁 Plano de execução

**Antes de tudo:** `az account set --subscription b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058` (CLI fica em DIGITAL-NPROD por padrão).

- [x] **1. Terraform** — pasta `DIGITAL-PROD/stp-dig-rg-blogagent-prd/`. Cria RG + 8 recursos, mesmos nomes/tiers (Function B1, Search free, OpenAI S0, Redis Balanced_B0, Storage Standard_LRS).
- [x] **2. OpenAI** — republicar deployments `gpt-4o-mini` + `text-embedding-ada-002` (GlobalStandard). *(fora do IaC)*
- [x] **3. AI Search** — reupload do dataset/índice. *(dev/GO AI)* — subiu como `blog-index` (ver gotcha do índice abaixo).
- [x] **4. Env vars** — migradas `-prod`→`-prd` (mesma função, só mudou `-g`).
- [x] **5. Deploy** — esteira reexecutada, achou o RG `-prd`.
- [x] **6. APIM** — rotas no `stp-dig-apim-aihub-prd` + subscription key.
- [x] **7. Validação** — Claude conferiu via az cli (recursos, deployments, env vars, deploy, rotas, índice).
- [x] **8. Excluir `-prod`** — `terraform destroy` concluído + RG removido.

---

## 📒 Log de execução

- **2026-06-23** — Chamado criado por Joao Henrique Pfingstag Barth. Aguardando aprovações (SRE, Arquitetura Sistemas, SN_REVISOR_Infraestrutura). Terraform do `-prd` preparado no repo. Nova change para o CAB será aberta pelo Joao.
- **2026-06-24** — Aprovado. Task **TASK1255089** (Cloud/k8s) aberta e atribuída ao Felipe. Iniciando execução: `terraform init/plan/apply` na pasta `stp-dig-rg-blogagent-prd/`.
- **2026-06-24** — ⚠️ **`apply` do `-prd` FALHOU parcialmente.** Criados: RG, App Insights, Service Plan (nomes RG-scoped). Falharam 4 recursos por **conflito de nome global** com o `-prod` ainda existente:
  - OpenAI `stp-dig-cog-blogagent-prd` → `409 CustomDomainInUse` (subdomínio reservado).
  - AI Search `stp-dig-srch-blogagent-prd` → `400 ServiceNameUnavailable`.
  - Redis `stp-dig-redis-blogagent-prd` → `400 name is not available`.
  - Storage `stpdigblogagentprd` → `409 StorageAccountAlreadyExists`.
  - **Causa:** nomes idênticos entre `-prod` e `-prd` (de propósito, p/ não mudar endpoints) são **globais** → os dois RGs **não coexistem**. Plano "criar -prd → validar → destruir -prod" é **inviável** p/ esses 4.
  - **Plano corrigido:** (1) `terraform destroy` no `-prod`; (2) **purgar** o OpenAI soft-deleted se necessário; (3) `terraform apply` no `-prd` (state já tem os 3 parciais, cria só os 4 restantes).
  - ✅ **Aprendizado-chave:** recursos de **nome global** (Storage, Cognitive/OpenAI subdomain, AI Search, Redis Enterprise) **não podem ter -prod e -prd simultâneos**. Em renomeação de RG com nomes idênticos, é **destruir o antigo ANTES** de criar o novo — não há janela de coexistência/rollback.
- **2026-06-24** — 💾 **Backup das 26 env vars** da func `-prod` exportado p/ `appsettings-prod-backup.json` (antes do destroy). Gerado `appsettings-prd-import.json` (20 vars, sem as 6 auto-geridas) p/ o merge na func nova. Ambos no `.gitignore` (contêm secrets), junto com `tfplan`.
- **2026-06-24** — 🗑️ **`destroy` do `-prod` concluído** (8 recursos). RG não apagou sozinho por causa de **recurso órfão fora do TF**: `Failure Anomalies - stp-dig-appi-blogagent-prd` (smartDetectorAlertRule auto-criado pelo App Insights). Resolvido com `az group delete --name stp-dig-rg-blogagent-prod --yes` (limpa aninhados). RG `-prod` confirmado removido (`az group exists` = false).
  - ✅ **Purge do OpenAI NÃO foi necessário:** o destroy removeu o Cognitive de vez (não ficou em soft-delete — `list-deleted` vazio, `show` = ResourceNotFound). Subdomínio livre. *(O aviso de 48h do erro 409 é genérico; nem sempre solta soft-delete.)*
- **2026-06-24** — ✅ **`apply` do `-prd` concluído** (5 added: OpenAI, Search, Storage, Function, Redis). RG `-prd` completo.
- **2026-06-24** — ✅ **Env vars migradas e validadas** (Claude, az cli):
  - Merge das 20 customizadas via `az functionapp config appsettings set --settings @file` (BOM do PowerShell removido com `tail -c +4` antes — `az` falha com BOM).
  - 3 chaves atualizadas com valores novos: `AZURE_OPENAI_KEY` (`keys list key1`), `AZURE_SEARCH_KEY` (`search admin-key show`), `REDIS_ACCESS_KEY` (`az rest .../databases/default/listKeys`).
  - Validado: endpoints OpenAI/Search corretos, `REDIS_HOST_NAME` = `stp-dig-redis-blogagent-prd.brazilsouth.redis.azure.net` (bate com host real), `REDIS_PORT=10000`. Total **26 settings** na func.
  - Backups locais (gitignored): `appsettings-prod-backup.json` (26 originais), `appsettings-prd-import.json` (20 p/ merge).
- **2026-06-24** — ✅ **Felipe recriou os 2 deployments no Foundry novo** (`stp-dig-cog-blogagent-prd`): `gpt-4o-mini` (2024-07-18) + `text-embedding-ada-002` (v2), ambos GlobalStandard. Validado via az cli: nomes batem com as vars `AZURE_OPENAI_*_DEPLOYMENT`.
- **2026-06-30** — ✅ **Esteira reexecutada com sucesso**: CTASK0136882 (deploy do pacote de release), Release#14, run `28255040925`, repo `SemParar-B2C/pyaz-ai-blogagent`. RG `-prd` encontrado, sem mais `ResourceGroupNotFound`.
- **2026-06-30** — ✅ **CTASK0137390 — Configuração das rotas no APIM** (change CHG0096865, 11h-12h):
  - API `stp-dig-func-blogagent-prd` importada da Function App no APIM `stp-dig-apim-aihub-prd`, backend = `stp-dig-func-blogagent-prd`.
  - **Gotcha do `urlTemplate` se repetiu** (igual NPRD): import automático criou as 7 operações (GET/POST/PUT/DELETE/HEAD/OPTIONS/PATCH) com `//{route}` (barra dupla). Felipe corrigiu manualmente uma a uma no portal (Design → Frontend → editar template). Validado via `az rest` no fim: **7/7 operações com `/{route}` correto**, zero barra dupla.
  - **Subscription key criada** com escopo restrito só a essa API (`scope: .../apis/stp-dig-func-blogagent-prd`), nome `stp-dig-func-blogagent-prd` — não usou a `sub-aihub-prd` (que seria all-access a todas APIs do Hub, escopo largo demais).
- **2026-06-30** — 🐛 **Gotcha do índice resolvido**: var `AZURE_SEARCH_INDEX` apontava `agent-blog-index`, mas o índice real subido pelo dev no AI Search `-prd` ficou `blog-index` (sem o prefixo). **Decisão do Joao: manter `blog-index`** (ajustar a var, não reupar o índice). Felipe trocou `AZURE_SEARCH_INDEX = blog-index` direto no Function App settings (portal) e salvou.
- **2026-06-30** — 🐛 **Var faltante descoberta no agente SEO**: a func tinha `APPLICATIONINSIGHTS_CONNECTION_STRING` (nome padrão Azure), mas o código esperava `APPINSIGHTS_CONNECTION_STRING` (nome diferente, sem o prefixo `APPLICATION`). Joao pediu para **adicionar** essa variável extra (não trocar a existente) com o **mesmo valor** da `APPLICATIONINSIGHTS_CONNECTION_STRING`. Felipe adicionou e **reiniciou o recurso** (restart necessário pra aplicar app settings novos). Ambas as variáveis (`APPLICATIONINSIGHTS_CONNECTION_STRING` e `APPINSIGHTS_CONNECTION_STRING`) coexistem agora na func, com o mesmo valor.
  - 💡 **Aprendizado:** confirmar com o time de dev os nomes EXATOS de env var que o código espera antes do go-live — `APPINSIGHTS_*` vs `APPLICATIONINSIGHTS_*` é uma pegadinha comum (são nomes Azure parecidos mas distintos; um é o legado/Instrumentation Key style, outro é o moderno/connection string style — times às vezes hardcodam o nome errado).

### ✅ Status final
Todos os 8 passos do plano concluídos. RG `-prd` completo e funcional, env vars corretas (incluindo os 2 gotchas de nome resolvidos), rotas do APIM sem barra dupla, deploy da esteira passando. RG `-prod` destruído e removido.

---

## 🔗 Notas relacionadas

| Nota | Relação |
|---|---|
| [[Setup PRD do Agente de Duvidas do Blog Free Flow]] | **Change de origem** — encerrada incompleta pelo mismatch `-prod`/`-prd`. |
| [[APIM AIHub - 404 em operacao por urlTemplate com barra dupla]] | Gotcha do APIM, reincidente nesta task também. |
| [[Setup PRD do Agente de IA no App]] | Roteiro de referência (setup de IA na Azure). |
