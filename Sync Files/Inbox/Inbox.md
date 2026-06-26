---
tipo: hub
criado: 2026-06-25
tags: [inbox, índice]
---
# 📥 Inbox

> Captura rápida e itens ambíguos. Triados pela skill `/daily` (passo 3) e roteados pelo `auto-brain`.
> Meta: manter esta pasta **vazia** — tudo aqui é trabalho pendente de organização.

## A processar
```dataview
TABLE WITHOUT ID file.link AS "Nota", criado AS "Criado", tags AS "Tags"
FROM "Sync Files/Inbox"
WHERE file.name != "Inbox"
SORT file.mtime DESC
```
