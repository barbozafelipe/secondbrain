---
tags: [estudo, carreira, pdi, terraform, iac, azure, oci]
updated: 2026-05-06
objetivo: 2 módulos Terraform funcionais (OCI + Azure) documentados até 31/10/2026
---

# 🏗️ Especialização Terraform — Azure e OCI

> [!tip] Como usar esta nota
> Quando um lembrete do TickTick tocar, **venha aqui primeiro**. Localize a etapa na tabela abaixo, clique no link e siga o primeiro passo indicado na nota. Uma etapa por vez é suficiente.

> [!note] Contexto
> Esta especialização começa **depois da certificação AWS** (prova em 01/08/2026). O prazo do PDI é 31/10/2026 — há tempo suficiente para fazer com qualidade, sem correria.

---

## 📊 Progresso por Etapa

```dataviewjs
const base = "Estudos/Especialização Terraform";

const etapas = [
  { file: `${base}/TF-01 - Fundamentos e Módulos Reutilizáveis`, label: "TF-01 — Fundamentos e Módulos",  peso: 25 },
  { file: `${base}/TF-02 - Módulo OCI`,                          label: "TF-02 — Módulo OCI",            peso: 25 },
  { file: `${base}/TF-03 - Módulo Azure`,                        label: "TF-03 — Módulo Azure",          peso: 25 },
  { file: `${base}/TF-04 - CI-CD e Documentação de Patterns`,    label: "TF-04 — CI/CD + Documentação", peso: 25 },
];

let totalTasks = 0;
let totalDone  = 0;
const rows = [];

for (const e of etapas) {
  const page = dv.page(e.file);
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

  rows.push([e.label, e.peso + "%", done + " / " + total, pct + "%", bar]);
}

const totalPct    = totalTasks > 0 ? Math.round((totalDone / totalTasks) * 100) : 0;
const totalFilled = Math.round(totalPct / 5);
const totalBar    = "█".repeat(totalFilled) + "░".repeat(20 - totalFilled);

rows.push(["**GERAL**", "100%", "**" + totalDone + " / " + totalTasks + "**", "**" + totalPct + "%**", totalBar]);

dv.table(["Etapa", "Peso", "Itens", "% feito", "Progresso"], rows);
```

---

## 🔔 Trilha de Lembretes — O que fazer quando tocar

| # | Lembrete | Data | Abrir esta nota |
|---|---|---|---|
| 1 | Estudar fundamentos Terraform + módulos reutilizáveis | 14/08/2026 (Sex) · 16h | [[TF-01 - Fundamentos e Módulos Reutilizáveis]] |
| 2 | Criar módulo funcional para provisionamento OCI | 11/09/2026 (Sex) · 16h | [[TF-02 - Módulo OCI]] |
| 3 | Criar módulo funcional para provisionamento Azure | 09/10/2026 (Sex) · 16h | [[TF-03 - Módulo Azure]] |
| 🎯 | Implementar CI/CD com Terraform + Documentar 2 patterns | 29/10/2026 (Qui) · 14h | [[TF-04 - CI-CD e Documentação de Patterns]] |

---

## 📚 Módulos de Estudo

- [[TF-01 - Fundamentos e Módulos Reutilizáveis]] — Base: HCL, state, providers, módulos
- [[TF-02 - Módulo OCI]] — Entregar módulo funcional para OCI
- [[TF-03 - Módulo Azure]] — Entregar módulo funcional para Azure
- [[TF-04 - CI-CD e Documentação de Patterns]] — GitHub Actions + 2 patterns em infra/runbooks/

---

## 🔗 Links Úteis

- [HashiCorp Tutorials — Terraform](https://developer.hashicorp.com/terraform/tutorials)
- [Terraform Registry — Módulos oficiais](https://registry.terraform.io/)
- [Provider OCI (Oracle)](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [Provider AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions — Terraform workflow oficial](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)

---

%% Begin Waypoint %%
- [[TF-01 - Fundamentos e Módulos Reutilizáveis]]
- [[TF-02 - Módulo OCI]]
- [[TF-03 - Módulo Azure]]
- [[TF-04 - CI-CD e Documentação de Patterns]]

%% End Waypoint %%
