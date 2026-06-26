# Skill: /daily — Abrir o Dia com Contexto do Vault

## O que fazer

1. Calcular a data de hoje (`YYYY-MM-DD`) **e o dia da semana** (nunca chutar).
2. Ler `Sync Files/Diário/[hoje].md` se existir. Se não existir, criar com o template abaixo.
3. Checar `Sync Files/Inbox/` por capturas não processadas — se houver, listar e perguntar se quer triar agora (rotear pelas pastas do auto-brain).
4. Aplicar a regra de dia da semana:
   - **Seg / Qua / Sex** → dia de treino. Perguntar qual grupo muscular (ver divisão em [[Academia]]).
   - **Ter / Qui** → dia presencial. Acordou às 6h. Prioridades de trabalho primeiro.
5. Surfaçar progresso físico recente: ler `Sync Files/Pessoal/Academia.md`, `Sync Files/Pessoal/Saúde.md` e o último peso registrado em dailies anteriores vs metas (80kg massa magra, Índice de Adonis).
6. Perguntar: **"No que estamos trabalhando hoje?"**

## Template de Daily Note

> Caminho: `Sync Files/Diário/[YYYY-MM-DD].md`

```markdown
---
tipo: daily
criado: [YYYY-MM-DD]
tags: [diário]
---
# [YYYY-MM-DD] ([dia-da-semana])

## Métricas (campos inline — preencher se medir hoje)
peso:: 
treino:: 

## Foco do Dia
- 

## Trabalho
- [ ] 
- [ ] 

## Captura Rápida
- 

## Fim do Dia
- O que foi feito:
- O que ficou:
- Delta físico/mental:
```

### Notas
- `peso::` e `treino::` são campos Dataview: quando preenchidos, aparecem sozinhos no [[Fitness Dashboard]]. Se vazios, são ignorados nas queries.
- Medidas corporais completas (cintura, ombros, BF%) vão na tabela de [[Medidas]], não aqui.
- O dia da semana no título ajuda a bater rotina (treino vs presencial) num relance.
