---
tags: [azure, ai-search, gotcha, terraform, tier, blogagent]
tipo: gotcha
criado: 2026-07-14
---

# AI Search — 409 `ServiceDeleting` ao recriar com o mesmo nome (troca de tier free→basic)

> [!warning] Sintoma
> Ao trocar o tier de um Azure AI Search (ex: `free`→`basic`), o Terraform faz **destroy + create** (o `sku` é ForceNew). O destroy completa em segundos, mas o **create falha** com:
> ```
> Error: creating Search Service ... unexpected status 409 (409 Conflict) with error:
> ServiceDeleting: Cannot provision service named 'stp-dig-srch-blogagent-prd' because a
> background operation is still in progress, please try again with exponential backoff
> or with a different service name
> ```

## Causa

O **nome do AI Search fica reservado num registro global do Azure** por um tempo **depois** do delete — e esse release é **independente** do ARM. Ou seja:
- `az search service show -n <nome> -g <rg>` já retorna **`ResourceNotFound`** (ARM não vê mais o recurso)...
- ...mas o **backend do Search ainda segura o nome**, então recriar com o **mesmo nome** dá 409.

Não é erro de config, de state, nem de permissão. É timing do Azure.

## Por que não dá pra "forçar"

- **AI Search NÃO tem `purge`** (diferente do Cognitive/OpenAI, que tem `az cognitiveservices account purge`).
- O nome precisa ser **mantido** (a função e o APIM apontam pra ele por nome/endpoint), então **não** é opção usar nome diferente.
- Só resta **esperar** (exponential backoff).

## Quanto tempo esperar

De poucos minutos até **~30-45 min** para liberar o nome. Tentativas repetidas seguidas **não ajudam** (nem pioram) — só confirmam que ainda está travado.

## Procedimento correto

1. `terraform apply tfplan` → se der `ServiceDeleting`, **NÃO** fica martelando.
2. Espera **~15 min**.
3. Se o plan salvo reclamar `Saved plan is stale` (o apply anterior mexeu no state), refaz: `terraform plan -out tfplan`.
4. `terraform apply tfplan`.
5. Repete o ciclo (15 min de espera) até passar. Se > ~45 min travado (raro), considerar ticket no suporte Azure.

## Estado do Terraform durante a espera

- O destroy **saiu do state** (recurso removido). O create falhou → o recurso **não está** no state.
- Então o plano fica sempre `1 to add, 0 to change, 0 to destroy` (só criar). Nenhum outro recurso é afetado — é seguro repetir o apply.

## ⚠️ Efeitos colaterais da recriação (lembrar)

- **Índice(s) apagado(s):** recriar o Search zera todos os índices → precisa reupload do dataset (time de dev/GO AI).
- **Admin key nova:** `AZURE_SEARCH_KEY` na function fica stale → atualizar com a key nova (`az search admin-key show --service-name <nome> -g <rg> --query primaryKey -o tsv`). O `AZURE_SEARCH_ENDPOINT` **não muda** (é baseado no nome).

## Contexto de origem

Descoberto na **CHG0097262** (CTASK0138124, troca de tier do `stp-dig-srch-blogagent-prd` free→basic p/ melhoria do RAG do agente Free Flow). Ver [[Recriar RG blogagent como prd e excluir prod]] e [[Setup PRD do Agente de Duvidas do Blog Free Flow]].

> 💡 **Nota histórica:** o Search foi criado em `free` no setup inicial ("menor tier possível" pedido pelo negócio). Free **não é usável em produção** para RAG (sem SLA, 3 índices / 50MB, sem escala) — acabou tendo que virar `basic`. Lição: para RAG produtivo, já provisionar `basic` de saída.
