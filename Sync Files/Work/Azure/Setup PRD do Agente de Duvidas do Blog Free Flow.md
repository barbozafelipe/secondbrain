---
tags: [change, azure, ai-foundry, azure-functions, apim, ai-search, rag, blogagent, freeflow, setup-ambiente, prd]
status: encerrada-incompleta
criado: 2026-06-22
execucao: 2026-06-23
encerramento: 2026-06-23
resultado: falha-parcial
causa-raiz: rg-nomeado-prod-em-vez-de-prd
follow-up: RITM0903921
chamado: CHG0096757
---

# CHG0096757 — Setup PRD do Agente de Dúvidas do Blog Free Flow

> [!info] Resumo de uma linha
> Subir em **produção** o agente de IA que responde dúvidas na página do **Free Flow** no site Sem Parar. Stack: **Azure AI Foundry + Azure AI Search (RAG) + Azure Functions + APIM**. Change de *Setup de Ambiente* (produto novo, não impacta outros serviços).

---

> [!failure] DESFECHO (23/06) — Change ENCERRADA INCOMPLETA
> A change foi fechada como **falha parcial**. Tasks 1, 2, 3 concluídas; a **task 4 (deploy via esteira) falhou** e travou as tasks 5 e 6.
>
> **Causa-raiz — erro de nomenclatura na origem:** o chamado de criação criou o RG como **`stp-dig-rg-blogagent-prod`** (com `-prod`), mas a pipeline de deploy procura **`stp-dig-rg-blogagent-prd`** (com `-prd`, padrão do restante dos RGs). Resultado na esteira:
> ```
> RESOURCE_GROUP_NAME stp-dig-rg-blogagent-prd
> ERROR: (ResourceGroupNotFound) Resource group 'stp-dig-rg-blogagent-prd' could not be found.
> ```
> Ou seja, **não foi erro de execução das minhas tasks** — eu provisionei tudo conforme o chamado pedia (`-prod`). O typo veio no texto do chamado original.
>
> **Por que não dá só renomear:** Azure **não renomeia Resource Group**. E `az resource move` entre RGs **não é suportado** para **AI Search** nem **Redis Enterprise (Managed Redis)** — então "migrar" = **recriar** via Terraform.
>
> **Encaminhamento:**
> - 🎫 Follow-up no chamado **RITM0903921** (item Azure / ação Configuração) — criar `stp-dig-rg-blogagent-prd` com mesmos recursos/tiers e **excluir** `stp-dig-rg-blogagent-prod`. Aguardando aprovações (SRE, Arquitetura Sistemas, SN_REVISOR_Infraestrutura; Cloud/k8s já aprovado).
> - 📅 Nova **change** será levada ao CAB (Joao Henrique Pfingstag Barth) no dia seguinte para reexecutar o setup sobre o RG `-prd`.
> - 📁 Terraform do `-prd` **já preparado** no repo: `DIGITAL-PROD/stp-dig-rg-blogagent-prd/` (diff vs `-prod` = só nome do RG em `resource_group.tf` e key do state em `provider.tf`).
>
> Detalhes da reconstrução + migração de env vars na seção **[[#🔁 Plano de reconstrução em -prd (RITM0903921)]]** no fim da nota.

---

## 📋 Descrição da Change

> **Solicitação do Negócio:** implementação de um agente para sanar dúvidas na página do Free Flow no site Sem Parar.
> **Objetivo:** realizar o setup do ambiente **produtivo** do Agente de Dúvidas do Blog sobre Free Flow.
> **Tecnologias:** Azure AI Search, Azure Functions, APIM.
> **Scripts de banco:** nenhum.
> **Usado por outra aplicação?** Não. Só é consultado pela página do Free Flow. O não funcionamento não impacta disponibilidade de nenhum outro produto.

- **Subscription:** `b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058`
- **RG do produto:** `stp-dig-rg-blogagent-prod`
- **RG do APIM (compartilhado):** `stp-dig-rg-aihub-prd`
- **Janela:** 23-06-2026, 09:00 → 19:00 (10h planejadas, 6 CTASKs em sequência)

---

## 🎯 Minhas tasks (grupo Cloud/k8s): **1, 3, 5**

`CTASK0136879` · `CTASK0136881` · `CTASK0136883`. As demais (2, 4, 6) são do time de **dev/IA (GO AI)** — interlocutor: **Joao Henrique Pfingstag Barth**.

---

## ✅ Checklist na ordem de execução

### 1️⃣ CTASK0136879 — **MINHA** · Cloud · 09:00–10:00 (1h) · ✅ **ENCERRADA**
**Provisionar 2 modelos no Azure AI Foundry.**
- Recurso: `stp-dig-cog-blogagent-prd` (RG `stp-dig-rg-blogagent-prod`)
- Modelos (Deployments) — confirmados via `az cognitiveservices account deployment list`:
  - [x] `gpt-4o-mini` — chat (SKU GlobalStandard)
  - [x] `text-embedding-ada-002` — embeddings (alimenta o RAG) (SKU GlobalStandard)
- ⚠️ Deployments criados **na mão/portal, fora do Terraform** → na reconstrução `-prd` precisam ser **republicados** (não vêm no `apply`).
- É a 1ª task, abre a janela. Destrava o passo 2 (dataset/RAG).
- **Precedente:** [[Setup PRD do Agente de IA no App]] / CTASK0132395 (lá foram 5 modelos no `aiagentapp`). Mesmo procedimento: Foundry → Deployments → criar deployment por modelo.

### 2️⃣ CTASK0136880 — *outro (dev/GO AI)* · 10:00–12:00 (2h) · ✅ **ENCERRADA**
**Subir o dataset do RAG no Azure AI Search.**
- Recurso: `stp-dig-srch-blogagent-prd` (RG `stp-dig-rg-blogagent-prod`), num índice.
- Executado pelo time de dev do produto. **Não é minha**, mas depende do meu passo 1 (embedding model).

### 3️⃣ CTASK0136881 — **MINHA** · Cloud · 12:00–14:30 (2h30) · ✅ **ENCERRADA**
**Adicionar variáveis de ambiente na Azure Function.**
- Recurso: `stp-dig-func-blogagent-prd` (RG `stp-dig-rg-blogagent-prod`) → Function App → *Environment variables / Configuration*.
- 🔑 **Ação prévia:** pegar a lista de variáveis com o **GO AI (Joao Henrique Pfingstag Barth)**. Já alinhado no Teams (ele disse que pega com a dev tudo que precisa). **Cobrar a lista ANTES da janela** pra não atrasar.
- ✅ **Divisão confirmada pelo João (Teams, 23/06 09h):** *"a primeira ctask é pra criar os modelos, vão sair variáveis de lá... vamos precisar que vc pegue pra nós algumas, não temos permissão pra ver todas em produção."* Ou seja: os valores secretos de PRD (🔒) **eu** coleto no recurso e repasso; o resto (nomes de vars, valores não-secretos) o dev monta.
- **Valores que eu coleto (vêm da task 1 + AI Search):**
  - Foundry `stp-dig-cog-blogagent-prd` → *Keys and Endpoint*: `AZURE_OPENAI_ENDPOINT`, `AZURE_OPENAI_API_KEY`/`FOUNDRY_API_KEY` 🔒, `AZURE_OPENAI_CHAT_DEPLOYMENT=gpt-4o-mini`, `AZURE_OPENAI_EMBEDDING_DEPLOYMENT=text-embedding-ada-002`, `FOUNDRY_EMBEDDINGS_URL`, `AZURE_OPENAI_API_VERSION`.
  - AI Search `stp-dig-srch-blogagent-prd` → *Keys*: `AZURE_SEARCH_ENDPOINT`, `AZURE_SEARCH_API_KEY` 🔒, `AZURE_SEARCH_INDEX_NAME`.
- 🔒 **Segurança:** não colar key de prod no chat do Teams (fica no histórico). Passar na call/screen-share ou usar **Key Vault reference** (`@Microsoft.KeyVault(...)`) no App Settings em vez do valor cru.

> [!success] EXECUÇÃO (23/06) — feito via `az functionapp config appsettings set --settings @file.json`
> O Joao Henrique Pfingstag Barth mandou a lista de 22 vars. Gravados **20** (preservando as 6 que já existiam na function). Comando só faz merge: adiciona/atualiza o que está no arquivo e mantém o resto. Total final: **26 settings**.
>
> **Secrets que eu coletei nos recursos** (não vieram na lista): `AZURE_OPENAI_KEY` (de `stp-dig-cog-blogagent-prd`), `REDIS_ACCESS_KEY` (de `stp-dig-redis-blogagent-prd` — é **Azure Managed Redis / redisEnterprise**, key via `az rest .../databases/default/listKeys`, não `az redis list-keys`). A `AZURE_SEARCH_KEY` o João mandou em texto.
>
> **2 erros pegos na lista do Joao Henrique Pfingstag Barth (corrigidos antes de gravar):**
> 1. `AZURE_SEARCH_ENDPOINT` vinha como `stp-dig-srch-aihub-nprd` (nprd, recurso errado). **Provei** que era typo: a `AZURE_SEARCH_KEY` fornecida == primary admin key de `stp-dig-srch-blogagent-prd` (prod). Corrigido p/ `https://stp-dig-srch-blogagent-prd.search.windows.net`.
> 2. `AZURE_OPENAI_EMBEDDING_MODEL_DEPLOYMENT` vinha `ada-embedding-azure`, mas o deployment criado no Foundry chama `text-embedding-ada-002`. João decidiu alinhar a var p/ `text-embedding-ada-002`.
>
> **Pulados** (já existiam, regra "não alterar existentes"): `APPINSIGHTS_INSTRUMENTATIONKEY` e `APPINSIGHTS_CONNECTION_STRING`. Obs.: o nome exato `APPINSIGHTS_CONNECTION_STRING` nem existia — o que há é `APPLICATIONINSIGHTS_CONNECTION_STRING` (nome padrão). Se o código do dev ler o nome exato, fica sem valor — confirmar com o GO AI se necessário.
>
> 💡 **Aprendizado p/ próximas:** sempre cruzar `AZURE_SEARCH_KEY` × `az search admin-key show` e os nomes em `AZURE_OPENAI_*_DEPLOYMENT` × `az cognitiveservices account deployment list` antes de gravar — as listas de env var do dev vêm com typo de copy/paste entre nprd/prd.
- **Precedente:** [[Setup PRD do Agente de IA no App]] / CTASK0132397 (lá foi um Web App; aqui Function App — mesma lógica de lista KEY=VALUE: chaves OpenAI/Foundry, endpoint/key/index do AI Search, etc.).
- Tem que estar pronta **antes** do deploy (passo 4).

### 4️⃣ CTASK0136882 — *outro (Producao/dev)* · 14:30–15:30 (1h) · ❌ **FALHOU**
**Deploy do pacote de release das Functions via esteira.**
- Artefato: GitHub Actions run `27351571078` (Release#9), repo `SemParar-B2C/pyaz-ai-blogagent`.
- **Não é minha**, mas **depende do meu passo 3** (env vars precisam estar no recurso antes do deploy/restart).
- 🛑 **FALHA:** esteira abortou com `ResourceGroupNotFound` — variável `RESOURCE_GROUP_NAME=stp-dig-rg-blogagent-prd` (pipeline espera `-prd`), mas o RG provisionado é `-prod`. **Não é erro da Function nem das env vars** — é o mismatch de nome do RG. Foi o ponto que encerrou a change como incompleta. Resolução pelo RITM0903921 (recriar como `-prd`).

### 5️⃣ CTASK0136883 — **MINHA** · Cloud · 15:30–16:30 (1h) · ⏭️ **NÃO EXECUTADA** (change encerrada antes)
**Configurar rotas no APIM + criar novo par de chaves de subscrição.**
> Não cheguei a executar — a change foi encerrada incompleta após a falha da task 4. Será refeita na change de reconstrução `-prd`. O gotcha do `urlTemplate //{route}` (abaixo) **continua valendo** pra próxima execução.
- APIM: `stp-dig-apim-aihub-prd` (RG `stp-dig-rg-aihub-prd`) — ⚠️ **APIM COMPARTILHADO do AI Hub**, não é do RG do blogagent. Decisão de usar o APIM do AI Hub foi por **redução de custos** (alinhado com o João no Teams). Cuidado ao mexer em policies/rotas pra não afetar outras APIs existentes.
- Backend da API = Function App `stp-dig-func-blogagent-prd`.
- [ ] Criar a API apontando pro backend.
- [ ] Criar **novo par de subscription keys** (primary/secondary) → entregar pro time de validação (passo 6).
- 🚨 **GOTCHA (NPRD deu 404 por isso):** garantir `urlTemplate = /{route}` em **todas** as operações (GET/POST/PUT/DELETE/...). Em NPRD a operação POST ficou com `//{route}` (barra dupla) e deu **404**. Padrão de referência: API `blogagent-hml-nprd`. Conferir logo após criar. Detalhe completo em [[APIM AIHub - 404 em operacao por urlTemplate com barra dupla]].
- Contexto do backend (de NPRD): função `http_app_func`, rota catch-all `/{*route}`, `authLevel = ANONYMOUS`. Rota efetiva do agente: `POST .../ask`.

### 6️⃣ CTASK0136884 — *outro (Funcional/GO AI)* · 16:30–19:00 (2h30) · ⏭️ **NÃO EXECUTADA** (change encerrada antes)
**Validar acesso às Functions via APIM (Postman).**
- **Não é minha**, mas **depende do meu passo 5** (rotas + subscription key). Entregar a key pra eles testarem.

---

## 🔗 Dependências críticas (pra eu não travar)

```
1️⃣ modelos ──▶ 2️⃣ dataset RAG
                 3️⃣ env vars ──▶ 4️⃣ deploy ──▶ 6️⃣ validação
                                  5️⃣ rotas APIM ─────┘ (entrega a key)
```

- **Antes da janela:** cobrar do **Joao Henrique Pfingstag Barth (GO AI)** a lista de variáveis (task 3) e confirmar quais valores eu gero vs. ele passa.
- Minhas tasks **destravam** as dos outros: 1 destrava o dev (2); 3 tem que estar pronta antes do deploy (4); 5 entrega a key pra validação (6).
- **Único ponto que toca infra compartilhada:** o APIM do AI Hub (task 5).

---

## 🧠 Ancoragem Mental

> Essa change é o **gêmeo em PRD** do produto que eu já vi em NPRD (blog agent). É praticamente o mesmo roteiro da [[Setup PRD do Agente de IA no App]] (setup de IA na Azure: modelos → env vars → APIM), só que aqui o backend é **Azure Functions** (não Web App) e o APIM é o **compartilhado do AI Hub** (`stp-dig-apim-aihub-prd`), não um dedicado do produto.
>
> Os dois lugares onde eu mais posso me queimar:
> 1. **Env vars (task 3)** — depender da dev e dos valores `< obter no recurso >`. Resolver a lista antes.
> 2. **APIM (task 5)** — a **barra dupla no `urlTemplate`** que já causou 404 em NPRD. `/{route}`, não `//{route}`.

---

## 🔁 Plano de reconstrução em -prd (RITM0903921)

> Encaminhamento da falha da CHG0096757. Objetivo: recriar o stack no RG `stp-dig-rg-blogagent-prd` (com `-prd`), validar, e excluir o `-prod`. Terraform já pronto em `DIGITAL-PROD/stp-dig-rg-blogagent-prd/`.

**Por que recriar (e não mover):** Azure não renomeia RG; `az resource move` **não suporta** AI Search nem Redis Enterprise. Como nada funcional crítico subiu no `-prod`, recriar é seguro.

**Subscription:** sempre `az account set --subscription b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058` antes (a CLI fica em DIGITAL-NPROD por padrão).

### Passos
1. **Terraform** (pasta `stp-dig-rg-blogagent-prd/`): `init` → `plan -out tfplan` → `apply tfplan`. Cria RG + 8 recursos (mesmos nomes `-prd`, mesmos tiers: Function B1, Search free, OpenAI S0, Redis Balanced_B0, Storage Standard_LRS).
2. **Passos manuais fora do IaC:**
   - Republicar deployments OpenAI: `gpt-4o-mini` + `text-embedding-ada-002` (GlobalStandard).
   - Reupload do dataset no AI Search (parte do dev/GO AI).
3. **Migrar env vars** `-prod`→`-prd` (mesma função `stp-dig-func-blogagent-prd`, só muda `-g`):
   - Export: `az functionapp config appsettings list -g stp-dig-rg-blogagent-prod -n stp-dig-func-blogagent-prd -o json > appsettings-prod.json`
   - **Endpoints NÃO mudam** (derivam do nome do recurso, que é idêntico): `AZURE_OPENAI_ENDPOINT`, `AZURE_SEARCH_ENDPOINT`, `REDIS_HOST_NAME` (confirmar host do Redis Enterprise).
   - **Só 3 chaves mudam** (instâncias novas): `AZURE_OPENAI_KEY`, `AZURE_SEARCH_KEY`, `REDIS_ACCESS_KEY` — buscar valores novos dos recursos `-prd`.
   - **NÃO copiar** as auto-geridas (o módulo TF seta sozinho, valores antigos quebrariam): `AzureWebJobsStorage`, `AzureWebJobsDashboard`, `APPLICATIONINSIGHTS_CONNECTION_STRING`, `APPINSIGHTS_INSTRUMENTATIONKEY`, `FUNCTIONS_EXTENSION_VERSION`, `FUNCTIONS_WORKER_RUNTIME`.
   - Redis Enterprise key via REST: `az rest --method post --url ".../redisEnterprise/stp-dig-redis-blogagent-prd/databases/default/listKeys?api-version=2024-09-01-preview" --query primaryKey -o tsv`.
4. **Validação** (az cli): recursos criados, deployments OpenAI, env vars corretas, deploy da esteira passando (agora acha o RG `-prd`), rotas APIM (cuidado `urlTemplate /{route}`, não `//{route}`).
5. **Só DEPOIS de validado:** `terraform destroy` no `-prod` e apagar a pasta `stp-dig-rg-blogagent-prod` do repo.

### 💡 Aprendizados para próximas changes de setup de ambiente
- **Validar o nome do RG no chamado × padrão das pipelines ANTES de provisionar.** O padrão dos RGs é sufixo `-prd`; o chamado veio com `-prod` e ninguém pegou até o deploy falhar. Um diff rápido do nome contra outros RGs (`stp-dig-rg-*-prd`) teria evitado a recriação inteira.
- **Mapear o que é IaC × manual.** Deployments OpenAI e dataset do Search **não** estão no Terraform — toda reconstrução precisa refazê-los à mão. Documentar isso no chamado evita "criei o RG e achei que acabou".
- **AI Search e Redis Enterprise não suportam mover de RG** → qualquer correção de RG nesses recursos é sempre recriação, nunca move.

---

## 🔗 Notas relacionadas

| Nota | Relação |
|---|---|
| [[Setup PRD do Agente de IA no App]] | **Mesmo tipo de change** (setup de IA na Azure: modelos + env vars + APIM). Roteiro de referência. |
| [[APIM AIHub - 404 em operacao por urlTemplate com barra dupla]] | **Mesmo produto** (blog agent) em NPRD. Gotcha do `urlTemplate //{route}` → 404, direto na minha task 5. |
| RITM0903921 | **Follow-up desta change** — recriação do RG como `-prd` + exclusão do `-prod`. |
