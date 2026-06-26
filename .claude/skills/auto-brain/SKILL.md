# Skill: auto-brain — Alimentar o Second Brain automaticamente

## Quando executar

No **final de cada conversa** em que houve conteúdo pertinente, **antes de encerrar**.
Avise o Felipe: "📝 Criei a nota **[Nome]** em `[pasta]`."

---

## Critérios de pertinência

### ✅ CRIAR nota quando a conversa produzir:
- Conhecimento técnico reutilizável (troubleshooting, conceitos, padrões, arquitetura)
- Decisão importante (técnica, profissional, médica, de projeto)
- Resumo de reunião processada
- Aprendizado novo sobre ferramenta, serviço ou tecnologia
- Task de trabalho estruturada (chamados, CTASKs, CHGs)
- Informação médica (consulta, exame, prescrição)
- Progresso de projeto pessoal

### ❌ NÃO criar nota quando:
- Conversa trivial (formatação, typo, pergunta rápida sem aprendizado)
- Conteúdo já existe em nota similar no vault (verificar antes!)
- Felipe pedir explicitamente para não criar
- Conversa for apenas sobre o vault/organização em si (meta-conversa)
- Debug pontual sem aprendizado generalizável

---

## Roteamento — em qual pasta salvar

| Conteúdo | Pasta |
|---|---|
| Troubleshooting / task Azure | `Sync Files/Work/Azure/` |
| Troubleshooting / task AWS | `Sync Files/Work/AWS/` |
| Troubleshooting / task GCP | `Sync Files/Work/GCP/` |
| Troubleshooting / task OCI | `Sync Files/Work/OCI/` |
| Okta / Identity | `Sync Files/Work/Okta/` |
| Zscaler | `Sync Files/Work/Zscaler/` |
| Rancher / K8s | `Sync Files/Work/Rancher/` |
| Certificados / rotação | `Sync Files/Work/Certificados/` |
| Carreira / feedback / 1:1 | `Sync Files/Work/Carreira/Sem Parar - Corpay/` |
| Certificação / estudo | `Sync Files/Estudos/` (subpasta existente ou nova) |
| Consulta / exame médico | `Sync Files/Médico/` (subpasta da especialidade) |
| Projeto Draco | `Sync Files/Projetos/Draco/` |
| Projeto Second Brain | `Sync Files/Projetos/Second Brain Agent/` |
| Reunião semanal | `Sync Files/Work/Reuniões semanais/` |
| Novo domínio claro | Criar pasta nova com bom senso |
| Ambíguo | Perguntar ao Felipe |

---

## Template da nota

```markdown
---
tipo: nota
tags: [auto-brain, domínio, tecnologia, ...]
criado: YYYY-MM-DD
status: ativo
fonte: conversa-claude
---

# Título Descritivo

> TL;DR — 1-2 frases do que esta nota cobre.

## Conteúdo

[Conhecimento destilado — NÃO dump da conversa inteira.
Médio: ~300-500 tokens. Tasks/troubleshooting: mais detalhado com código.]

## Links Relacionados

- [[Nota existente]] — relação prática
```

### Regras do template
- **Frontmatter obrigatório**: `tipo`, `tags` (incluindo `auto-brain`), `criado`, `status`, `fonte`
- **TL;DR obrigatório**: sempre ter o resumo de 1-2 frases
- **Profundidade média por padrão** (~300-500 tokens de corpo)
- **Profundidade detalhada** para tasks e troubleshooting (com código, tabelas, checklists)
- **Wikilinks**: usar `[[Nome]]` para referenciar notas existentes do vault
- **Não editar blocos Waypoint** (`%% Begin Waypoint %%`) — o plugin atualiza sozinho

---

## Nomeação do arquivo

| Tipo | Formato | Exemplo |
|---|---|---|
| Task/chamado | ID do chamado | `TASK1248999.md` |
| Knowledge base | Descritivo com underscores | `Azure_Private_Endpoints_Troubleshooting.md` |
| Consulta médica | Data DD-MM-YYYY | `03-06-2026.md` |
| Reunião | Data DD-MM-YYYY | `02-06-2026.md` |
| Conceito/estudo | Nome descritivo | `Terraform_State_Locking.md` |

---

## Deduplicação

Antes de criar, verificar:
1. Existe arquivo com nome igual ou similar na pasta-alvo? → **atualizar** em vez de criar
2. O assunto já está coberto em outra nota? (ex: BGP já tem `Roteamento_BGP_ExpressRoute.md`) → **não duplicar**, no máximo complementar
3. Na dúvida, complementar nota existente > criar nota nova

---

## Custo estimado

- Leitura da skill: ~400 tokens (uma vez por sessão)
- Verificação de pasta + deduplicação: ~200 tokens
- Geração da nota: ~300-600 tokens
- **Total extra por conversa: ~900-1200 tokens** (menos de 1 centavo)
