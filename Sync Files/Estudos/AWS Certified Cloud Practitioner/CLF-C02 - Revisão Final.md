---
tags: [estudo, aws, certificação, clf-c02, revisão]
updated: 2026-05-06
---

# 🔁 CLF-C02 — Revisão Final

Parte de: [[AWS Certified Cloud Practitioner]]

---

## 🔔 Lembrete 9 — Revisão Final de todos os domínios

**Data:** 28/07/2026 (Ter) · 16h | ⏱️ Tempo estimado: 45 min

> [!info] Primeiro passo (2 min)
> Esta sessão **não é para aprender coisas novas**. É para ativar o que você já sabe. Leia cada seção abaixo em ritmo de revisão — como se estivesse passando o olho. Se algo parecer obscuro, consulte a nota do domínio correspondente por no máximo 5 minutos.

> [!tip] Por que isso funciona
> A revisão espaçada (spaced repetition) é a técnica com maior evidência científica para retenção de longo prazo. Você estudou há semanas — rever agora, logo antes da prova, consolida a memória de forma muito mais eficiente do que estudar tudo de novo.

---

## ✅ Checklist desta sessão

- [ ] Revisar Domínio 1 — Cloud Concepts (~8 min)
- [ ] Revisar Domínio 2 — Security & Compliance (~12 min)
- [ ] Revisar Domínio 3 — Cloud Technology & Services (~15 min)
- [ ] Revisar Domínio 4 — Billing, Pricing & Support (~8 min)
- [ ] Confirmar logística da prova (~2 min)

---

## 📌 Domínio 1 — Cloud Concepts (24%)

| Conceito | Regra rápida |
|---|---|
| CapEx → OpEx | Cloud elimina investimento fixo |
| Elasticidade | Escala para cima e para baixo sob demanda |
| IaaS / PaaS / SaaS | Você gerencia: SO / código / só dados |
| Well-Architected | 6 pilares: OpEx, Security, Reliability, Performance, Cost, Sustainability |
| 6 Rs de migração | Rehost, Replatform, Repurchase, Refactor, Retire, Retain |
| CAF | 6 perspectivas: Business, People, Governance, Platform, Security, Operations |
| AZ vs Region | AZ = datacenter isolado / Region = conjunto de AZs |

---

## 📌 Domínio 2 — Security & Compliance (30%)

| Conceito | Regra rápida |
|---|---|
| Shared Responsibility | AWS cuida DO cloud / você cuida NO cloud |
| IAM Users/Groups/Roles | Users = pessoa / Groups = conjunto / Roles = serviços e federated |
| Least Privilege | Conceder só o mínimo necessário |
| MFA | Obrigatório para root e acesso ao console |
| GuardDuty | Detecção de ameaças via ML |
| Inspector | Vulnerabilidades em EC2 e containers |
| Macie | PII no S3 |
| Shield Standard | DDoS automático e gratuito |
| WAF | Firewall de aplicação web |
| CloudTrail | Auditoria de TODAS as chamadas de API |
| AWS Config | Conformidade de configuração ao longo do tempo |
| AWS Artifact | Relatórios de compliance (SOC, PCI, ISO) |

---

## 📌 Domínio 3 — Cloud Technology & Services (34%)

**Computação**

| Serviço | Regra rápida |
|---|---|
| EC2 | VMs — você gerencia o SO |
| Lambda | Serverless, cobrado por invocação |
| ECS / EKS | Containers: ECS = AWS-native / EKS = Kubernetes |
| Fargate | Containers sem gerenciar nodes |
| Elastic Beanstalk | PaaS — sobe o código, AWS cuida do resto |

**Armazenamento**

| Serviço | Regra rápida |
|---|---|
| S3 | Object storage — buckets e objetos |
| EBS | Block storage persistente para EC2 |
| EFS | File system compartilhado (NFS) |
| Glacier | Arquivamento barato — acesso lento |

**Banco de Dados**

| Serviço | Tipo |
|---|---|
| RDS / Aurora | Relacional gerenciado |
| DynamoDB | NoSQL serverless, ms de latência |
| Redshift | Data warehouse |
| ElastiCache | Cache Redis / Memcached |

**Rede**

| Conceito | Regra rápida |
|---|---|
| Security Group | Stateful — por instância — só Allow |
| NACL | Stateless — por subnet — Allow e Deny |
| Direct Connect | Link físico dedicado on-premises ↔ AWS |
| VPN Site-to-Site | Túnel IPSec via internet |
| CloudFront | CDN via Edge Locations |

**Mensageria / Integração**

| Serviço | Modelo |
|---|---|
| SQS | Fila (pull) — desacopla produtor e consumidor |
| SNS | Pub/sub (push) — notifica múltiplos assinantes |
| EventBridge | Barramento de eventos entre serviços |

**Monitoramento**

| Serviço | Função |
|---|---|
| CloudWatch | Métricas, logs, alarmes |
| CloudTrail | Auditoria de API |
| Trusted Advisor | Recomendações de custo, segurança, performance |
| Systems Manager | Gerencia frota de EC2 |

---

## 📌 Domínio 4 — Billing, Pricing & Support (12%)

| Conceito | Regra rápida |
|---|---|
| On-Demand | Sem compromisso — imprevisível |
| Reserved (RI) | 1–3 anos — até 72% desconto — previsível |
| Savings Plans | Compromisso de $/hora — mais flexível que RI |
| Spot | Interrompível — até 90% desconto — tolerante a falhas |
| Dedicated Host | Hardware físico dedicado — compliance / licença |
| Cost Explorer | Visualiza e prevê gastos |
| AWS Budgets | Alertas de orçamento |
| Organizations | Multi-conta com SCPs e fatura consolidada |
| Suporte Basic | Grátis — documentação + 7 checks Trusted Advisor |
| Suporte Business | $100+/mês — 24/7, SLA 1h, Trusted Advisor completo |

---

## 🗓️ Logística da prova — confirme antes de dormir

> [!important] Prova: **01/08/2026 (Sábado)**

- [ ] Confirmar horário e endereço do centro de teste (está no e-mail de confirmação do Pearson VUE)
- [ ] Documento com foto separado e acessível
- [ ] Dormir bem na sexta-feira — o cérebro consolida memória durante o sono
- [ ] Chegar 30 min antes do horário marcado
- [ ] Não revisar conteúdo na manhã da prova — confie no trabalho que você fez

> [!success] Você está pronto
> Revisou os 4 domínios. Fez 2 simulados. Tem meses de experiência real com AWS no trabalho.
> A prova é só a formalização do que você já é.
