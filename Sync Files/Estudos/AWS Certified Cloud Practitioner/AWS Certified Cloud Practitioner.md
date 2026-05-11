---
tags: [estudo, carreira, pdi, aws, certificação, clf-c02]
updated: 2026-05-06
objetivo: Aprovação no CLF-C02 até 01/08/2026
---

# ☁️ AWS Certified Cloud Practitioner — CLF-C02

> [!tip] Como usar esta nota
> Quando um lembrete do TickTick tocar, **venha aqui primeiro**. Localize a etapa na tabela abaixo, clique no link e siga o primeiro passo indicado na nota. Uma etapa por vez é o suficiente para chegar lá.

---

## 📊 Progresso por Domínio

```dataviewjs
const base = "Estudos/AWS Certified Cloud Practitioner";

const domains = [
  { file: `${base}/CLF-C02 - Cloud Concepts`,                label: "Cloud Concepts",              peso: 24 },
  { file: `${base}/CLF-C02 - Security and Compliance`,       label: "Security & Compliance",       peso: 30 },
  { file: `${base}/CLF-C02 - Cloud Technology and Services`, label: "Cloud Technology & Services", peso: 34 },
  { file: `${base}/CLF-C02 - Billing, Pricing and Support`,  label: "Billing, Pricing & Support",  peso: 12 },
];

let totalTasks = 0;
let totalDone  = 0;
const rows = [];

for (const d of domains) {
  const page = dv.page(d.file);
  let done = 0, total = 0;

  if (page) {
    const tasks = page.file.tasks;
    total = tasks.length;
    done  = tasks.where(t => t.completed).length;
  }

  totalTasks += total;
  totalDone  += done;

  const pct    = total > 0 ? Math.round((done / total) * 100) : 0;
  const filled = Math.round(pct / 5);
  const bar    = "█".repeat(filled) + "░".repeat(20 - filled);

  rows.push([d.label, d.peso + "%", done + " / " + total, pct + "%", bar]);
}

const totalPct    = totalTasks > 0 ? Math.round((totalDone / totalTasks) * 100) : 0;
const totalFilled = Math.round(totalPct / 5);
const totalBar    = "█".repeat(totalFilled) + "░".repeat(20 - totalFilled);

rows.push(["**GERAL**", "100%", "**" + totalDone + " / " + totalTasks + "**", "**" + totalPct + "%**", totalBar]);

dv.table(["Domínio", "Peso na prova", "Tópicos", "% estudo", "Progresso"], rows);
```

---

## 🔔 Trilha de Lembretes — O que fazer quando tocar

> Cada linha é um lembrete no TickTick. Ao tocar: abra esta nota → clique no link → siga o **Primeiro Passo** da nota que abrir.

| # | Lembrete | Data | Abrir esta nota |
|---|---|---|---|
| ✅ | Cloud Concepts — revisão (7/8 tópicos) | Qualquer momento livre | [[CLF-C02 - Cloud Concepts]] |
| 1 | Revisar Security & Compliance | 14/05/2026 (Qui) · 16h | [[CLF-C02 - Security and Compliance]] |
| 2 | Revisar Cloud Technology & Services | 21/05/2026 (Qui) · 16h | [[CLF-C02 - Cloud Technology and Services]] |
| 3 | Revisar Billing, Pricing & Support | 28/05/2026 (Qui) · 16h | [[CLF-C02 - Billing, Pricing and Support]] |
| 4 | Pesquisar vouchers e descontos | 04/06/2026 (Qui) · 10h | [[CLF-C02 - Vouchers e Agendamento]] |
| 5 | Fazer simulado oficial 1 | 11/06/2026 (Qui) · 16h | [[CLF-C02 - Simulados]] |
| 6 | Revisar pontos fracos do simulado 1 | 18/06/2026 (Qui) · 16h | [[CLF-C02 - Simulados]] |
| 7 | Fazer simulado oficial 2 | 25/06/2026 (Qui) · 16h | [[CLF-C02 - Simulados]] |
| 8 | Agendar prova (Pearson VUE / PSI) | 02/07/2026 (Qui) · 10h | [[CLF-C02 - Vouchers e Agendamento]] |
| 9 | LAST WEEK STUDY — Semana final de revisão | 25/07/2026 (Sáb) | [[CLF-C02 - Revisão Final]] |
| 🎯 | **REALIZAR PROVA CLF-C02** | **01/08/2026 (Sáb)** | Pearson VUE / PSI — presencial |

---

## 📚 Módulos de Estudo por Domínio

- [[CLF-C02 - Cloud Concepts]] — Domínio 1 · **24%** · ✅ Quase concluído
- [[CLF-C02 - Security and Compliance]] — Domínio 2 · **30%** ← *mais testado em IAM e compliance*
- [[CLF-C02 - Cloud Technology and Services]] — Domínio 3 · **34%** ← *maior peso da prova*
- [[CLF-C02 - Billing, Pricing and Support]] — Domínio 4 · **12%**

---

## 📋 Módulos de Apoio

- [[CLF-C02 - Vouchers e Agendamento]] — Como conseguir desconto e como agendar a prova
- [[CLF-C02 - Simulados]] — Simulados 1 e 2 + revisão de pontos fracos
- [[CLF-C02 - Revisão Final]] — Revisão compacta de todos os domínios (última sessão antes da prova)

---

## 🔗 Links Úteis

- [Exam Guide CLF-C02 (PDF oficial)](https://d1.awsstatic.com/training-and-certification/docs-cloud-practitioner/AWS-Certified-Cloud-Practitioner_Exam-Guide.pdf)
- [AWS SkillBuilder — Cloud Essentials Learning Plan](https://explore.skillbuilder.aws/learn/public/learning_plan/view/82/cloud-essentials-learning-plan)
- [Simulado oficial (20 questões grátis)](https://explore.skillbuilder.aws/learn/course/external/view/elearning/14050/aws-certified-cloud-practitioner-official-practice-question-set-clf-c02-english)
- [Página oficial da certificação](https://aws.amazon.com/certification/certified-cloud-practitioner/)
- [Pearson VUE — Agendar prova](https://home.pearsonvue.com/aws)

---

%% Begin Waypoint %%
- **[[CLF-C02 - Security and Compliance]]**
	- [[Responsabilidade compartilhada]]
- [[CLF-C02 - Billing, Pricing and Support]]
- [[CLF-C02 - Cloud Concepts]]
- [[CLF-C02 - Cloud Technology and Services]]
- [[CLF-C02 - Revisão Final]]
- [[CLF-C02 - Simulados]]
- [[CLF-C02 - Vouchers e Agendamento]]

%% End Waypoint %%
