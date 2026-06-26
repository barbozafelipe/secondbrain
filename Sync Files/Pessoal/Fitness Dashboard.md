---
tipo: hub
criado: 2026-06-25
tags: [fitness, dashboard]
---
# 💪 Fitness Dashboard

> Meta: **80 kg de massa magra** · Índice de Adonis ombro/cintura **~1.618**
> Hubs: [[Academia]] (treino) · [[Saúde]] (sono/derma/cirurgia) · log completo em [[Medidas]]
> Rode `/fitness` para o delta brutal vs metas.

## ⚖️ Tendência de peso (dos daily notes)
> Aparece automaticamente quando você loga `peso:: NN` num daily note.
```dataview
TABLE WITHOUT ID file.link AS "Dia", peso AS "Peso (kg)", mm AS "MM (kg)"
FROM "Sync Files/Diário"
WHERE peso
SORT file.name DESC
LIMIT 30
```

## 🏋️ Consistência de treino (últimos 14 registros)
> Esperado: 3x/semana (seg/qua/sex). Aparece quando você loga `treino:: <grupo>`.
```dataview
TABLE WITHOUT ID file.link AS "Dia", treino AS "Treino"
FROM "Sync Files/Diário"
WHERE treino
SORT file.name DESC
LIMIT 14
```

## 📏 Medidas
- Tabela completa de composição corporal: [[Medidas]]
- **Pendência base:** peso, altura e BF% atuais ainda não registrados (`TODO` em [[Academia]]).

## 🩺 Confounders ativos (de [[Saúde]])
- Déficit de sono profundo (N3 ~58 min/noite) → menos GH no sono → reparo muscular prejudicado.
- Cirurgia nasal (septo grau III) pendente — resolver melhora sono → composição.
- Acne-prone → dieta com reflexo direto (evitar excesso de gordura/laticínios).
