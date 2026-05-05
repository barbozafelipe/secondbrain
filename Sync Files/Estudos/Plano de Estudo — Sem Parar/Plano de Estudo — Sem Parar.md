---
tags: [estudo, carreira, pdi, aws, kubernetes, terraform]
updated: 2026-05-05
---

# 📚 Plano de Estudo — Sem Parar (Corpay)

> Baseado nas tarefas reais, week meetings e PDI. Cada trilha tem sua própria nota com checklist detalhado.

---

### 📊 Progresso por Trilha

```dataviewjs
const base = "Estudos/Plano de Estudo";

const trilhas = [
  { file: `${base}/Trilha 0 — Conformidade Sem Parar`,  label: "🔴 Trilha 0 — Conformidade",       prazo: "29/05/2026" },
  { file: `${base}/Trilha 1 — AWS em Profundidade`,     label: "🟠 Trilha 1 — AWS em Profundidade", prazo: "31/08/2026" },
  { file: `${base}/Trilha 2 — Kubernetes e GitOps`,     label: "🟡 Trilha 2 — Kubernetes + GitOps", prazo: "Contínuo"   },
  { file: `${base}/Trilha 3 — Observabilidade`,         label: "🔵 Trilha 3 — Observabilidade",     prazo: "Contínuo"   },
  { file: `${base}/Trilha 4 — Terraform`,               label: "⚪ Trilha 4 — Terraform",           prazo: "31/10/2026" },
];

let totalTasks = 0;
let totalDone  = 0;
const rows = [];

for (const t of trilhas) {
  const page = dv.page(t.file);
  let done = 0, total = 0;

  if (page) {
    const tasks = page.file.tasks;
    total = tasks.length;
    done  = tasks.where(tk => tk.completed).length;
  }

  totalTasks += total;
  totalDone  += done;

  const pct    = total > 0 ? Math.round((done / total) * 100) : 0;
  const filled = Math.round(pct / 5);
  const bar    = "█".repeat(filled) + "░".repeat(20 - filled);

  rows.push([t.label, t.prazo, done + " / " + total, pct + "%", bar]);
}

const gPct    = totalTasks > 0 ? Math.round((totalDone / totalTasks) * 100) : 0;
const gFilled = Math.round(gPct / 5);
const gBar    = "█".repeat(gFilled) + "░".repeat(20 - gFilled);

rows.push(["**GERAL**", "—", "**" + totalDone + " / " + totalTasks + "**", "**" + gPct + "%**", gBar]);

dv.table(["Trilha", "Prazo", "Itens", "% concluído", "Progresso"], rows);
```

---

### 🗂️ Trilhas

- [[Trilha 0 — Conformidade Sem Parar]] — 🔴 **Prazo: 29/05/2026 — URGENTE**
- [[Trilha 1 — AWS em Profundidade]] — 🟠 Prazo: 31/08/2026 (exame CLP)
- [[Trilha 2 — Kubernetes e GitOps]] — 🟡 Contínuo
- [[Trilha 3 — Observabilidade]] — 🔵 Contínuo
- [[Trilha 4 — Terraform]] — ⚪ Prazo: 31/10/2026

---

### 📅 Cadência semanal

| Janela | Dias | O que fazer |
|---|---|---|
| Almoço (30–45min) | Seg / Qua / Sex | 1 item da trilha ativa — leitura, doc ou vídeo curto |
| Deslocamento (áudio) | Ter / Qui | Podcast técnico ou overview em vídeo (sem precisar de tela) |
| Sábado manhã (1–1,5h) | 1× por semana | Prática no console, kubectl ou lab |

---

### 🔗 Conexão com o PDI (Qulture.Rocks)

| Meta do PDI | Trilha aqui | Prazo | Status |
|---|---|---|---|
| Trilha Sem Parar (ESG/LGPD/Assédio) | [[Trilha 0 — Conformidade Sem Parar\|Trilha 0]] | 29/05/2026 | 🔴 Não iniciado |
| AWS Certified Cloud Practitioner | [[Trilha 1 — AWS em Profundidade\|Trilha 1]] | 31/08/2026 | 🟡 Em progresso |
| Especialização Terraform (Azure + OCI) | [[Trilha 4 — Terraform\|Trilha 4]] | 31/10/2026 | ⚪ Não iniciado |
| Ciclo de Inglês Técnico (30h) | — (manter cadência) | 18/12/2026 | 🟡 Em progresso |

---

%% Begin Waypoint %%
- [[Trilha 0 — Conformidade Sem Parar]]
- [[Trilha 1 — AWS em Profundidade]]
- [[Trilha 2 — Kubernetes e GitOps]]
- [[Trilha 3 — Observabilidade]]
- [[Trilha 4 — Terraform]]

%% End Waypoint %%
