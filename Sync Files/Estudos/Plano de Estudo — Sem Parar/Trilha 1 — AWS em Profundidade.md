---
tags: [estudo, carreira, pdi, aws, iam, sso, s3, vpc, kinesis, dynamodb, eks, lambda]
updated: 2026-05-05
---

# 🟠 Trilha 1 — AWS em Profundidade

**Prazo: 31/08/2026 (exame CLP)** · Parte de: [[Plano de Estudo — Sem Parar]]

> O aprofundamento abaixo sustenta o trabalho diário — não só a prova.
> Recurso base: [AWS Skill Builder](https://skillbuilder.aws). Encaixe nos almoços (30–45min) dos dias remotos.

---

## ✅ 1A — Fundamentos que sustentam tudo

- [ ] **IAM** — Policies, Roles, Trust Policies, SCP, Permission Boundaries
- [ ] **AWS Organizations + IAM Identity Center** — multi-conta, SSO, Assignments
- [ ] **S3** — Bucket Policies, cross-account, lifecycle, presigned URLs
- [ ] **VPC** — Subnets, Security Groups, NACLs, Route Tables, Peering

---

## ✅ 1B — Serviços que você JÁ tocou (entender o porquê)

- [ ] **Kinesis Data Streams** — shards, on-demand vs provisioned, retenção de dados
- [ ] **DynamoDB Streams** — Change Data Capture, view types (NEW\_AND\_OLD\_IMAGES)
- [ ] **Kinesis Firehose** — source → transform → destination, cross-account S3, buffer hints
- [ ] **IAM cross-account** — AssumeRole, resource-based policies, quando usar cada uma

---

## ✅ 1C — Serviços que vão chegar (Afinz + Olho no Carro)

- [ ] **EKS** — clusters, node groups, IRSA, kubeconfig, comparação com RKE
- [ ] **Lambda** — triggers (API GW, ALB, DynamoDB), cold start, permissões de execução
- [ ] **API Gateway** — REST vs HTTP API, integração com Lambda/ALB, authorizers
- [ ] **Transit Gateway** — attachments, route tables, TGW cross-account (contexto: Afinz → Fiserv)
- [ ] **Route 53** — hosted zones, private zones, alias records (contexto: Olho no Carro → R53)

---

## ✅ 1D — Certificação CLP (CLF-C02)

- [ ] Concluir todos os módulos do **AWS Cloud Practitioner Essentials** no Skill Builder
- [ ] Score ≥ 80% nos simulados oficiais em **2 rodadas consecutivas**
- [ ] Agendar prova no Pearson VUE ou PSI com **antecedência mínima de 15 dias** (até 16/08)
- [ ] ✅ Aprovação no exame **CLF-C02**
