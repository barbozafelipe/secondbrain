# Skill: /tldr — Salvar Sessão no Vault

## O que fazer

1. Analisar a conversa completa da sessão atual.
2. Extrair:
   - **Decisões tomadas** (técnicas, pessoais, de projeto)
   - **Coisas para lembrar** (fatos, contexto, aprendizados)
   - **Próximas ações** com responsável e prazo se mencionado
3. Determinar a pasta certa (estrutura real do vault):

   | Conteúdo | Pasta |
   |---|---|
   | Infra / cloud (Azure, AWS, GCP, OCI, Okta, Zscaler, Rancher) | `Sync Files/Work/<Provider>/` (ou `Sync Files/Work/` se transversal) |
   | Fitness / físico | `Sync Files/Pessoal/` |
   | Médico / saúde | `Sync Files/Médico/<Especialidade>/` |
   | Projeto Draco | `Sync Files/Projetos/Draco/` |
   | Projeto Second Brain | `Sync Files/Projetos/Second Brain Agent/` |
   | Estudo / certificação | `Sync Files/Estudos/` |
   | Vida pessoal (geral) | `Sync Files/Pessoal/` |
   | Reunião semanal | `Sync Files/Work/Reuniões semanais/` |
   | Ambíguo | `Sync Files/Inbox/` |

4. Salvar como `[pasta]/tldr-[YYYY-MM-DD].md`.
5. Se houver **preferência ou padrão novo aprendido sobre o Felipe** (não derivável do código/vault), registrar na **memória persistente** do Claude Code (não num `memory.md` no vault) — seguindo o protocolo de memória global.

## Formato do arquivo salvo

```markdown
---
tipo: tldr
criado: [YYYY-MM-DD]
tags: [tldr, <domínio>]
---
# TLDR — [YYYY-MM-DD]

> Sessão sobre: [1 frase]

## Decisões
- 

## Para Lembrar
- 

## Próximas Ações
- [ ] 
```

### Nota
- O frontmatter `tipo: tldr` faz a nota aparecer sozinha no [[Dashboard]] (seção de notas recentes).
- Se a sessão gerou conhecimento técnico reutilizável, considerar também o `auto-brain` (nota de conhecimento destilada), não só o tldr.
