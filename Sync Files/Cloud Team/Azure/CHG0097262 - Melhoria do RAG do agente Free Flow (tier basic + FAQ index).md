---
tags: [change, chg, azure, blogagent, freeflow, ai-search, rag, tier, prd, em-andamento]
status: em-execucao
criado: 2026-07-14
execucao: 2026-07-14
solicitante: Joao Henrique Pfingstag Barth
---

# CHG0097262 — Melhoria do RAG do agente Free Flow (tier basic + FAQ index)

> [!info] Resumo de uma linha
> Melhoria no RAG do agente de dúvidas do blog Free Flow: **subir o tier do AI Search de `free`→`basic`** e adicionar suporte a um **novo índice de FAQ** (`index-faq-freeflow`), além de melhorias de prompt (lado dev). Produto novo, não impacta outros serviços.

- **Motivo:** o AI Search foi criado em `free` no setup inicial, que **não é usável em produção** para RAG (sem SLA, limites baixos, sem escala). Negócio pediu melhoria do RAG → precisa `basic` + índice de FAQ.
- **Subscription:** `b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058` (DIGITAL-PROD)
- **RG:** `stp-dig-rg-blogagent-prd`

---

## ✅ Tasks (na ordem)

| Ordem | Task | Dono | Descrição | Status |
|---|---|---|---|---|
| 1 | **CTASK0138124** | **Felipe** (Cloud/k8s) | Trocar tier do AI Search `free`→`basic` (delete+recreate) | ✅ Feito |
| 2 | CTASK0138125 | Funcional/GO AI (João) | Rodar script Python que cria índice(s) + sobe dataset | ⏳ Pendente |
| 3 | **CTASK0137843** | **Felipe** (Cloud/k8s) | Add env vars na Function (`AZURE_SEARCH_FAQ_INDEX` + key) | 🟡 Parcial (ver abaixo) |
| 4 | CTASK0137844 | Produção | Deploy do release via esteira (Release#21, run `28970257889`) | ⏳ Pendente |

---

## 📒 Log de execução

- **2026-07-14 ~09:30** — ✅ **CTASK0138124 (tier free→basic)** via Terraform:
  - Editado `DIGITAL-PROD/stp-dig-rg-blogagent-prd/ai-search.tf`: `sku = "free"` → `"basic"`. Como `sku` é ForceNew, `terraform apply` fez **destroy + create** (bate com a descrição da CTASK: "recurso deletado e recriado com mesmo nome, pois free impossibilita troca de tier").
  - 🐛 **Bateu no gotcha `ServiceDeleting` 409** — o nome do Search ficou reservado no backend por vários minutos após o delete (mesmo `az` já mostrando ResourceNotFound). Levou ~15-30 min de backoff até o create passar. Detalhe completo em [[AI Search - ServiceDeleting 409 ao recriar com mesmo nome (troca de tier free-basic)]].
  - ✅ Validado via az cli: `sku: basic`, `status: running`, `provisioningState: succeeded`, índices vazios (esperado).
- **2026-07-14 ~10:19** — 🟡 **CTASK0137843 (env vars)** — Felipe optou por adiantar (a pedido do João) mesmo antes do upload do dev:
  - Adicionada `AZURE_SEARCH_FAQ_INDEX = index-faq-freeflow`.
  - Atualizada `AZURE_SEARCH_KEY` (o Search foi recriado → admin key nova). `AZURE_SEARCH_ENDPOINT` **não mudou** (baseado no nome).
  - ✅ Validado via az cli: `AZURE_SEARCH_KEY` da função **bate** com a primary key atual do Search; `AZURE_SEARCH_FAQ_INDEX=index-faq-freeflow`, `AZURE_SEARCH_INDEX=blog-index` (conteúdo, mantida).
  - **NÃO fechada ainda** — faltam 2 verificações que dependem da task 2 (ver pendências).

### ⏳ Pendências antes de fechar a CTASK0137843
- [ ] **Verificar os índices reais após o upload do dev (task 2).** A função aponta pra **DOIS** índices: `blog-index` (conteúdo) e `index-faq-freeflow` (FAQ). O Search foi recriado **vazio** → o script do dev precisa recriar **os dois**, não só o FAQ. Confirmar via az cli que ambos existem com o nome exato (risco do mesmo bug `blog-index` vs `agent-blog-index` de antes).
- [ ] **Rotacionar a `AZURE_SEARCH_KEY`.** ⚠️ A primary key foi **colada em texto puro no Teams** (para o dev rodar os scripts). Depois que o dev terminar o upload, rotacionar (`az search admin-key renew --key-kind primary`) para invalidar a key vazada, e atualizar a função com a nova.
  - 💡 **Lição:** admin key de Search em prod não deve ir por chat. Padrão melhor: passar a **secondary** key temporária pro dev e rotacionar depois; ou canal seguro.

---

## 🔗 Notas relacionadas

| Nota | Relação |
|---|---|
| [[AI Search - ServiceDeleting 409 ao recriar com mesmo nome (troca de tier free-basic)]] | Gotcha da task 1 (troca de tier). |
| [[Recriar RG blogagent como prd e excluir prod]] | Change anterior do mesmo produto (migração `-prod`→`-prd`). |
| [[Setup PRD do Agente de Duvidas do Blog Free Flow]] | Setup original do agente. |
