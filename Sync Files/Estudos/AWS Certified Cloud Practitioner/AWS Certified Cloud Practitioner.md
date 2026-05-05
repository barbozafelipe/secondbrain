
### <mark style="background: #BBFABBA6;">Web links:</mark>

- [Exam Guide CLF-C02 (PDF oficial)](https://d1.awsstatic.com/training-and-certification/docs-cloud-practitioner/AWS-Certified-Cloud-Practitioner_Exam-Guide.pdf)
- [AWS SkillBuilder – Cloud Essentials Learning Plan](https://explore.skillbuilder.aws/learn/public/learning_plan/view/82/cloud-essentials-learning-plan)
- [Página oficial da certificação](https://aws.amazon.com/certification/certified-cloud-practitioner/)
- [Simulado oficial (20 questões grátis)](https://explore.skillbuilder.aws/learn/course/external/view/elearning/14050/aws-certified-cloud-practitioner-official-practice-question-set-clf-c02-english)



### Obsidian Notes:

- [[CLF-C02 - Cloud Concepts]] — Domínio 1 · 24%
- [[CLF-C02 - Security and Compliance]] — Domínio 2 · 30%
- [[CLF-C02 - Cloud Technology and Services]] — Domínio 3 · 34%
- [[CLF-C02 - Billing, Pricing and Support]] — Domínio 4 · 12%



### <mark style="background: #ABF7F7A6;">Notas Complementares:</mark>



### <mark style="background: #D2B3FFA6;">Etapas:</mark>

- [ ] Ler o exam guide e mapear os 4 domínios
- [ ] Completar learning plan no AWS SkillBuilder
- [ ] Revisar [[CLF-C02 - Cloud Concepts]]
- [ ] Revisar [[CLF-C02 - Security and Compliance]]
- [ ] Revisar [[CLF-C02 - Cloud Technology and Services]]
- [ ] Revisar [[CLF-C02 - Billing, Pricing and Support]]
- [ ] Fazer os 2 simulados oficiais
- [ ] Score mínimo consistente de 80% antes de agendar
- [ ] Agendar prova (Pearson VUE ou PSI)

---

### 📊 Progresso Automático

```dataviewjs
const domains = [
  { file: "CLF-C02 - Cloud Concepts",              label: "Cloud Concepts",             peso: 24 },
  { file: "CLF-C02 - Security and Compliance",     label: "Security & Compliance",      peso: 30 },
  { file: "CLF-C02 - Cloud Technology and Services", label: "Cloud Technology & Services", peso: 34 },
  { file: "CLF-C02 - Billing, Pricing and Support", label: "Billing, Pricing & Support", peso: 12 },
];

let totalTasks = 0;
let totalDone  = 0;
const rows = [];

for (const d of domains) {
  const page  = dv.pages().where(p => p.file.name === d.file).first();
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

  rows.push([
    d.label,
    d.peso + "%",
    done + " / " + total,
    pct + "%",
    bar
  ]);
}

const totalPct    = totalTasks > 0 ? Math.round((totalDone / totalTasks) * 100) : 0;
const totalFilled = Math.round(totalPct / 5);
const totalBar    = "█".repeat(totalFilled) + "░".repeat(20 - totalFilled);

rows.push([
  "**GERAL**",
  "100%",
  "**" + totalDone + " / " + totalTasks + "**",
  "**" + totalPct + "%**",
  totalBar
]);

dv.table(
  ["Domínio", "Peso na prova", "Tópicos", "% estudo", "Progresso"],
  rows
);
```


%% Begin Waypoint %%
- [[CLF-C02 - Billing, Pricing and Support]]
- [[CLF-C02 - Cloud Concepts]]
- [[CLF-C02 - Cloud Technology and Services]]
- [[CLF-C02 - Security and Compliance]]

%% End Waypoint %%

