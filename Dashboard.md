---
tipo: hub
criado: 2026-06-25
tags: [dashboard]
---
# 🧠 Dashboard

> Camada **surface**: nada aqui é digitado à mão — tudo aparece sozinho via frontmatter + Dataview.
> Para abrir isto ao iniciar o Obsidian: plugin **Homepage** → definir `Dashboard` como homepage.

## 📅 Hoje
```dataview
LIST WITHOUT ID file.link
FROM "Sync Files/Diário"
WHERE file.name = dateformat(date(today), "yyyy-MM-dd")
```

## 📥 Inbox — a processar
```dataview
TABLE WITHOUT ID file.link AS "Nota", criado AS "Criado"
FROM "Sync Files/Inbox"
WHERE file.name != "Inbox"
SORT file.mtime DESC
LIMIT 10
```

## 🆕 Notas recentes (auto-brain)
```dataview
TABLE WITHOUT ID file.link AS "Nota", file.folder AS "Pasta", criado AS "Criado"
FROM #auto-brain
SORT criado DESC
LIMIT 15
```

## 📝 TLDRs recentes
```dataview
TABLE WITHOUT ID file.link AS "Sessão", criado AS "Data"
FROM "Sync Files"
WHERE tipo = "tldr"
SORT criado DESC
LIMIT 10
```

## ✅ TODOs abertos no vault
```dataview
TASK
FROM "Sync Files"
WHERE !completed
GROUP BY file.link
```

## 💪 Físico — links rápidos
- [[Fitness Dashboard]] · [[Academia]] · [[Saúde]] · [[Medidas]]
