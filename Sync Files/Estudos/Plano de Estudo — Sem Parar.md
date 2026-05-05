---
tags: [estudo, carreira, pdi, aws, kubernetes, terraform]
updated: 2026-05-05
---

# 📚 Plano de Estudo — Sem Parar (Corpay)

> Baseado nas tarefas reais, week meetings e PDI. Ordenado do mais urgente para o mais longo prazo.
> Marque cada item conforme concluir. O progresso é calculado automaticamente abaixo.

---

## 📊 Progresso por Trilha

```dataviewjs
const trilhas = [
  { label: "🔴 Trilha 0 — Conformidade (29/05)", tag: "trilha-0" },
  { label: "🟠 Trilha 1 — AWS em Profundidade",   tag: "trilha-1" },
  { label: "🟡 Trilha 2 — Kubernetes + GitOps",   tag: "trilha-2" },
  { label: "🔵 Trilha 3 — Observabilidade",        tag: "trilha-3" },
  { label: "⚪ Trilha 4 — Terraform (PDI Out)",    tag: "trilha-4" },
];

const page = dv.page(dv.current().file.path);
const allTasks = page.file.tasks;

const rows = [];
let totalDone = 0, totalAll = 0;

for (const t of trilhas) {
  const filtered = allTasks.where(tk => tk.text.includes(`#${t.tag}`));
  const done = filtered.where(tk => tk.completed).length;
  const total = filtered.length;
  totalDone += done;
  totalAll  += total;

  const pct    = total > 0 ? Math.round((done / total) * 100) : 0;
  const filled = Math.round(pct / 5);
  const bar    = "█".repeat(filled) + "░".repeat(20 - filled);
  rows.push([t.label, `${done} / ${total}`, `${pct}%`, bar]);
}

const gPct    = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0;
const gFilled = Math.round(gPct / 5);
const gBar    = "█".repeat(gFilled) + "░".repeat(20 - gFilled);
rows.push(["**GERAL**", `**${totalDone} / ${totalAll}**`, `**${gPct}%**`, gBar]);

dv.table(["Trilha", "Itens", "Progresso", "Barra"], rows);
```

---

## 🔴 Trilha 0 — Conformidade Sem Parar
> **PRAZO: 29/05/2026 — 25 dias. Não iniciado. Fazer antes de qualquer coisa.**
> Cursos curtos (~1–2h cada). Reserve o horário de almoço de segunda, quarta ou sexta.

- [ ] Concluir curso **ESG** na plataforma Sem Parar #trilha-0
- [ ] Concluir curso **LGPD** na plataforma Sem Parar #trilha-0
- [ ] Concluir curso **Assédio Moral e Sexual - Equipe** na plataforma Sem Parar #trilha-0
- [ ] Índice de conformidade = **100%** na plataforma #trilha-0

---

## 🟠 Trilha 1 — AWS em Profundidade
> **PRAZO: 31/08/2026 (exame CLP)**. Mas o aprofundamento abaixo sustenta o trabalho diário — não só a prova.
> Use o [AWS Skill Builder](https://skillbuilder.aws) como base. Encaixe nos almoços (30–45min) dos dias remotos.

### 1A — Fundamentos que sustentam tudo

- [ ] **IAM** — Policies, Roles, Trust Policies, SCP, Permission Boundaries #trilha-1
- [ ] **AWS Organizations + IAM Identity Center** — multi-conta, SSO, Assignments #trilha-1
- [ ] **S3** — Bucket Policies, cross-account, lifecycle, presigned URLs #trilha-1
- [ ] **VPC** — Subnets, Security Groups, NACLs, Route Tables, Peering #trilha-1

### 1B — Serviços que você JÁ tocou (entender o porquê)

- [ ] **Kinesis Data Streams** — shards, on-demand vs provisioned, retenção de dados #trilha-1
- [ ] **DynamoDB Streams** — Change Data Capture, view types (NEW\_AND\_OLD\_IMAGES) #trilha-1
- [ ] **Kinesis Firehose** — source → transform → destination, cross-account S3, buffer hints #trilha-1
- [ ] **IAM cross-account** — AssumeRole, resource-based policies, quando usar cada uma #trilha-1

### 1C — Serviços que vão chegar (Afinz + Olho no Carro)

- [ ] **EKS** — clusters, node groups, IRSA, kubeconfig, comparação com RKE #trilha-1
- [ ] **Lambda** — triggers (API GW, ALB, DynamoDB), cold start, permissões de execução #trilha-1
- [ ] **API Gateway** — REST vs HTTP API, integração com Lambda/ALB, authorizers #trilha-1
- [ ] **Transit Gateway** — attachments, route tables, TGW cross-account (contexto: Afinz → Fiserv) #trilha-1
- [ ] **Route 53** — hosted zones, private zones, alias records (contexto: Olho no Carro → R53) #trilha-1

### 1D — Certificação CLP (CLF-C02)

- [ ] Concluir todos os módulos do **AWS Cloud Practitioner Essentials** no Skill Builder #trilha-1
- [ ] Score ≥ 80% nos simulados oficiais em **2 rodadas consecutivas** #trilha-1
- [ ] Agendar prova no Pearson VUE ou PSI com **antecedência mínima de 15 dias** (até 16/08) #trilha-1
- [ ] ✅ Aprovação no exame **CLF-C02** #trilha-1

---

## 🟡 Trilha 2 — Kubernetes + GitOps
> Wellington quer te envolver com ArgoCD junto com o Lucas. Você já tem a base de RBAC — expanda daqui.
> Recurso principal: [Kubernetes docs](https://kubernetes.io/docs) + [ArgoCD docs](https://argo-cd.readthedocs.io).

### 2A — Kubernetes core

- [ ] **RBAC** — RoleBinding, ClusterRoleBinding, ClusterRole, diferença de escopo #trilha-2
- [ ] **Workloads** — Deployment, Pod, ReplicaSet, rollout, rollback via `kubectl` #trilha-2
- [ ] **HPA** — Horizontal Pod Autoscaler, métricas custom (PromQL), CPU vs HTTP requests #trilha-2
- [ ] **Helm** — charts, values.yaml, templates, install/upgrade/rollback #trilha-2

### 2B — GitOps com ArgoCD

- [ ] **Conceitos GitOps** — sync, drift detection, reconciliation loop, GitOps vs push-based #trilha-2
- [ ] **ArgoCD — Applications** — Application manifest, source, destination, sync policies #trilha-2
- [ ] **ArgoCD — App of Apps** — pattern usado para multi-cluster/multi-app #trilha-2
- [ ] Pedir ao **Lucas** para mostrar um Application real no cluster deles #trilha-2

---

## 🔵 Trilha 3 — Observabilidade
> Você não precisa dominar — mas precisa entender o suficiente para não travar numa tarefa.
> Encaixe no deslocamento Ter/Qui (áudio/vídeo).

- [ ] **Prometheus + PromQL básico** — métricas, labels, rate(), by clause ([cheat sheet](https://promlabs.com/promql-cheat-sheet/)) #trilha-3
- [ ] **CloudWatch** — Metrics, Log Groups, Log Insights, Alarms (você já usou para validar Lambda) #trilha-3
- [ ] **Dynatrace** — diferença OneAgent vs ActiveGate, o que o GCP Monitor faz no Autopilot #trilha-3

---

## ⚪ Trilha 4 — Terraform (PDI — Outubro)
> Não começar antes de setembro. Foco total no CLP até agosto.
> Recurso: [HashiCorp Tutorials](https://developer.hashicorp.com/terraform/tutorials).

- [ ] **HCL básico** — providers, resources, variables, outputs, locals #trilha-4
- [ ] **State** — local vs remote, S3 backend + DynamoDB locking, `terraform state` #trilha-4
- [ ] **Módulos reutilizáveis** — estrutura, inputs/outputs, Terraform Registry #trilha-4
- [ ] **Provider AWS** — EC2, S3, IAM em lab com conta de dev #trilha-4
- [ ] **Provider Azure** — resource group, virtual network, VM básica #trilha-4
- [ ] **Provider OCI** — comparar com Azure, documentar pattern no secondbrain #trilha-4
- [ ] **CI/CD com Terraform** — GitHub Actions + terraform plan/apply automatizado #trilha-4
- [ ] Criar **módulo funcional OCI** usado em prod ou lab, revisado por par #trilha-4
- [ ] Criar **módulo funcional Azure** usado em prod ou lab, revisado por par #trilha-4

---

## 📅 Cadência semanal

| Janela | Dias | O que fazer |
|---|---|---|
| Almoço (30–45min) | Seg / Qua / Sex | 1 item da trilha ativa — leitura, doc ou vídeo curto |
| Deslocamento (áudio) | Ter / Qui | Podcast técnico ou overview em vídeo (sem precisar de tela) |
| Sábado manhã (1–1,5h) | 1× por semana | Prática no console, kubectl ou lab |

---

## 🔗 Conexão com o PDI (Qulture.Rocks)

| Meta do PDI | Trilha aqui | Prazo | Status |
|---|---|---|---|
| Trilha Sem Parar (ESG/LGPD/Assédio) | Trilha 0 | 29/05/2026 | 🔴 Não iniciado |
| AWS Certified Cloud Practitioner | Trilha 1 | 31/08/2026 | 🟡 Em progresso |
| Especialização Terraform (Azure + OCI) | Trilha 4 | 31/10/2026 | ⚪ Não iniciado |
| Ciclo de Inglês Técnico (30h) | — (manter cadência) | 18/12/2026 | 🟡 Em progresso |
