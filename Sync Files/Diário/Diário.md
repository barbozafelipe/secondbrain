---
tipo: hub
criado: 2026-06-25
tags: [diário, índice]
---
# 📓 Diário

> Daily notes (`YYYY-MM-DD.md`). Criadas/abertas pela skill `/daily`.

## Todas as dailies
```dataview
TABLE WITHOUT ID file.link AS "Dia", peso AS "Peso", treino AS "Treino"
FROM "Sync Files/Diário"
WHERE tipo = "daily"
SORT file.name DESC
LIMIT 60
```
