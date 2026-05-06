
# CLF-C02 - Billing, Pricing and Support

**Domínio 4 · 12% da prova** | Parte de: [[AWS Certified Cloud Practitioner]]

---

## 🔔 Lembrete 3 — Revisar Billing, Pricing & Support

**Data:** 28/05/2026 (Qui) · 16h | ⏱️ Tempo estimado: 35 min *(domínio mais leve)*

> [!info] Primeiro passo (2 min)
> Olhe a tabela de modelos de preço do EC2 logo abaixo. Você já conhece Spot Instances do trabalho — isso é 20% deste domínio resolvido imediatamente. Siga pelo restante no ritmo.

> [!success] Ao terminar esta sessão
> Você terá coberto **100% do conteúdo dos 4 domínios**. Os estudos acabaram — é hora dos simulados.

---

## ✅ Checklist de Estudo

**Modelos de preço**
- [ ] On-Demand — sem compromisso, cobrado por hora ou segundo
- [ ] Reserved Instances — 1 ou 3 anos, desconto até 72%
- [ ] Savings Plans — compromisso de $/hora, mais flexível que RI
- [ ] Spot Instances — capacidade ociosa, até 90% de desconto (pode ser interrompida)
- [ ] Dedicated Hosts — servidor físico dedicado (compliance/licença)

**Gestão de custos**
- [ ] AWS Free Tier: Always Free, 12 meses, Trial
- [ ] AWS Cost Explorer — análise e previsão de gastos
- [ ] AWS Budgets — alertas quando custo/uso excede limite
- [ ] Cost and Usage Report (CUR) — relatório granular de todos os gastos
- [ ] AWS Pricing Calculator — estimativa de custo antes de provisionar
- [ ] Migration Evaluator (ex-TSO Logic) — análise de TCO para migração

**Planos de suporte**
- [ ] Basic — gratuito, documentação + Trusted Advisor limitado + Health Dashboard
- [ ] Developer — e-mail, horário comercial, 1 contato técnico
- [ ] Business — 24/7 telefone/chat, Trusted Advisor completo, SLA 1h crítico
- [ ] Enterprise On-Ramp — TAM compartilhado, SLA 30min p/ crítico
- [ ] Enterprise — TAM dedicado, SLA 15min p/ crítico, revisões de arquitetura

**Organizações e faturamento consolidado**
- [ ] AWS Organizations — gerenciar múltiplas contas com políticas (SCPs)
- [ ] Consolidated Billing — fatura única + descontos por volume consolidado
- [ ] Service Control Policies (SCPs) — limitar o que contas-filha podem fazer

---

## Modelos de Preço EC2

| Modelo | Compromisso | Desconto típico | Ideal para |
|---|---|---|---|
| **On-Demand** | Nenhum | — | Cargas imprevisíveis |
| **Reserved (RI)** | 1 ou 3 anos | até 72% | Cargas estáveis e previsíveis |
| **Savings Plans** | $/hora por 1-3 anos | até 66% | Flexibilidade de instância/região |
| **Spot** | Nenhum (pode ser interrompida) | até 90% | Cargas tolerantes a falha (batch, ML) |
| **Dedicated Host** | On-Demand ou Reserved | — | Licenças de software por socket/core |

> **Regra de ouro**: On-Demand para imprevisível · Reserved/Savings para previsível · Spot para tolerante a interrupção

---

## AWS Free Tier

| Tipo | Como funciona | Exemplo |
|---|---|---|
| **Always Free** | Sem expiração | Lambda: 1M invocações/mês |
| **12 meses** | Após criar a conta | EC2 t2.micro: 750h/mês |
| **Trial** | Tempo limitado por serviço | SageMaker: 2 meses |

---

## Ferramentas de Gestão de Custo

| Ferramenta | O que faz |
|---|---|
| **Cost Explorer** | Visualiza e analisa gastos históricos e faz previsão |
| **AWS Budgets** | Cria alertas de orçamento por custo, uso ou cobertura de RI |
| **Cost and Usage Report** | Relatório mais detalhado — integra com Athena/QuickSight |
| **Pricing Calculator** | Simula custo de uma arquitetura antes de criar |
| **Trusted Advisor** | Identifica recursos ociosos ou superprovisionados (custo) |

---

## Planos de Suporte

| Plano | Preço | SLA crítico | TAM | Trusted Advisor |
|---|---|---|---|---|
| **Basic** | Grátis | — | — | 7 checks |
| **Developer** | A partir de $29/mês | 12h (sistema prejudicado) | — | 7 checks |
| **Business** | A partir de $100/mês | 1h (sistema crítico) | — | Completo |
| **Enterprise On-Ramp** | A partir de $5.500/mês | 30min | Compartilhado | Completo |
| **Enterprise** | A partir de $15.000/mês | 15min | Dedicado | Completo |

---

## AWS Organizations e Faturamento Consolidado

- **AWS Organizations**: agrupa contas em OUs (Organizational Units) com hierarquia
- **Consolidated Billing**: todas as contas pagam em uma fatura única — compartilham descontos de volume (ex: S3, EC2 Reserved)
- **SCPs (Service Control Policies)**: define o que contas-filha podem ou não fazer — funciona mesmo que a conta tenha IAM permissivo

> SCPs não concedem permissão — só limitam o que é possível conceder via IAM
