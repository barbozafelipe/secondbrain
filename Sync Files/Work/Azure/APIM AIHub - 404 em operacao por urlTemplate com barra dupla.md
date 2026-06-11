---
aliases: [APIM 404, urlTemplate barra dupla, AIHub APIM, blog-agent-nprd]
tags: [azure, apim, troubleshooting, aihub, nprd]
---

# APIM AIHub (nprd) - 404 em `POST /blog-agent-nprd/ask`

## Contexto

- **Subscription:** `36df8ac5-dab6-4301-9cbf-97aa398ba021`
- **Resource Group:** `stp-dig-rg-aihub-nprd`
- **APIM:** `stp-dig-apim-aihub-nprd`
- **API:** `stp-dig-func-blogagent-nprd` (path `blog-agent-nprd`)
- **Custom domain:** `aihub-qa.semparar.com.br`

## Erro

```
curl --location 'https://aihub-qa.semparar.com.br/blog-agent-nprd/ask' \
--header 'Content-Type: application/json' \
--header 'Ocp-Apim-Subscription-Key: bc5144ef36ed4713a2829e507041fd58' \
--data '{ "message": "Como funciona o Sem Parar?", "conversation_id": "test-conversation-001", "token": "<jwt>" }'
```

Resposta: **HTTP 404**.

## Investigação

Descartado, na ordem:

1. **Custom domain** `aihub-qa.semparar.com.br` - configurado corretamente como hostname Proxy no APIM, certificado válido (CN correto, validade até 2027-02-11). Não é a causa.
2. **API existe** - `az apim api list` confirma `stp-dig-func-blogagent-nprd` com `path = blog-agent-nprd`, batendo com a URL chamada.
3. **Subscription key** `bc5144ef36ed4713a2829e507041fd58` - válida (`az rest ... listSecrets`), associada à subscription `blog-agent-nrpd` (note o typo no nome), `state = active`, `scope` aponta exatamente para essa API.
4. **Backend** - Function App `stp-dig-func-blogagent-nprd` (RG `stp-dig-rg-blogagent-nprd`) está `Running`, com função `http_app_func` em rota catch-all `/{*route}`, `authLevel = ANONYMOUS`. Backend saudável.
5. **Policies** - sem `rewrite-uri` em nenhum nível (global, API ou operação). Apenas `set-backend-service` + `rate-limit-by-key`.
6. **WAF/Imperva (Incapsula)** - descartado, pois um 404 "limpo" do APIM já explica o sintoma sem necessidade de envolver a camada de WAF/CDN.

## Causa raiz

```
az rest --method get .../apis/stp-dig-func-blogagent-nprd/operations?api-version=2022-08-01
```

| Método | urlTemplate |
|---|---|
| GET | `/{route}` ✅ correto |
| POST | `//{route}` ❌ **incorreto** |
| PUT/DELETE/PATCH/HEAD/OPTIONS | `//{route}` ❌ **incorreto** |

O APIM remove o prefixo `blog-agent-nprd` da URL chamada, restando `/ask`. Esse path:
- **casa** com `/{route}` (GET)
- **não casa** com `//{route}` (POST e demais verbos) - exigiria literalmente `//ask` (duas barras)

Sem operação correspondente, o gateway do APIM responde **404** antes mesmo de tentar rotear para o backend.

API de referência correta (mesmo padrão `http_app_func`): `blogagent-hml-nprd`, todas as operações com `urlTemplate = "/{route}"`.

## Correção aplicada

Removida a barra extra do `urlTemplate` da operação POST (`//{route}` → `/{route}`) via Portal/`az rest`. **Confirmado pelo usuário: 404 resolvido.**

```bash
az rest --method patch \
  --url "https://management.azure.com/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-aihub-nprd/providers/Microsoft.ApiManagement/service/stp-dig-apim-aihub-nprd/apis/stp-dig-func-blogagent-nprd/operations/post-http-app-func?api-version=2022-08-01" \
  --body '{"properties": {"displayName": "http_app_func", "method": "POST", "urlTemplate": "/{route}", "templateParameters": [{"name": "route", "required": true, "type": "string"}]}}'
```

## Pendências / atenção futura

- As operações **PUT/DELETE/PATCH/HEAD/OPTIONS** da mesma API (`stp-dig-func-blogagent-nprd`) ainda estão com `urlTemplate = "//{route}"`. Se algum desses métodos passar a ser usado, vai dar 404 pelo mesmo motivo. Aplicar a mesma correção proativamente, seguindo o padrão de `blogagent-hml-nprd`.
- Se essa API/operações forem gerenciadas via Terraform ou importadas de spec OpenAPI, corrigir o `url_template` na fonte também, para evitar que um próximo `apply`/import reverta o fix manual (drift reverso).
- Subscription `blog-agent-nrpd` tem typo no nome (deveria ser `nprd`). Baixa prioridade - subscriptions do APIM não podem ser renomeadas in-place, exigiria criar nova subscription e migrar a key.

## Como diagnosticar 404 em APIM (checklist geral)

1. Verificar se a API/path existe: `az apim api list`.
2. Verificar `urlTemplate` de cada operação: `az apim api operation list` (atenção a barras duplas/faltando).
3. Validar subscription key e produto associado: `az apim subscription show` / `listSecrets`.
4. Conferir custom domain e certificado: `az apim show --query hostnameConfigurations`.
5. Testar direto no gateway padrão (`*.azure-api.net`), bypassando custom domain/WAF, para isolar a camada que gera o 404.
6. Conferir `ApiManagementGatewayLogs` no Log Analytics para ver se o backend chegou a ser chamado (`backendResponseCode` vazio = gateway nunca encaminhou).
