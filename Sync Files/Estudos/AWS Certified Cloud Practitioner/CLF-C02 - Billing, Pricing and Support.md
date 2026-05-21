
# CLF-C02 - Billing, Pricing and Support

**Domínio 4 · 12% da prova** | Parte de: [[AWS Certified Cloud Practitioner]]

---

## 🔔 Lembrete 3 — Revisar Billing, Pricing & Support

**Data:** 28/05/2026 (Qui) · 16h | ⏱️ Tempo estimado: 35 min *(domínio mais leve)*

> [!info] Primeiro passo (2 min)
> Vá direto para a seção **AWS Organizations** abaixo. Você trabalha com multi-conta todos os dias — criação de contas, Permission Sets por conta, SCPs. Isso é 30% deste domínio. Comece pelo que já é seu terreno.

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
- [ ] Management Account — conta raiz da organização
- [ ] Organizational Units (OUs) — agrupamento de contas dentro da organização

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

O Organizations é o serviço que permite gerenciar **múltiplas contas AWS** como uma única organização. Funciona de forma muito similar ao que você viu hoje com Management Groups na Azure.

### Estrutura

```
Management Account (conta raiz / pagadora)
        |
        +--→ OU (Organizational Unit) — ex: Produção
        |         +--→ Conta STP PRD
        |         +--→ Conta CPP PRD
        |
        +--→ OU — ex: Desenvolvimento
                  +--→ Conta STP DEV
                  +--→ Conta STP QA
```

### Conceitos-chave

| Conceito | O que é |
|---|---|
| **Management Account** | Conta raiz — paga por todas, onde o Organizations é configurado |
| **Member Account** | Qualquer conta dentro da organização |
| **Organizational Unit (OU)** | Agrupamento de contas (como pastas) |
| **SCP (Service Control Policy)** | Política que limita o que as contas-filha podem fazer — mesmo se o IAM da conta permitir |
| **Consolidated Billing** | Fatura única + desconto por volume compartilhado entre contas |

> [!important] SCPs vs IAM Policies
> **SCP** define o teto máximo do que é possível fazer — funciona como uma guardrail.
> **IAM Policy** dentro da conta concede permissão real.
> Se a SCP bloqueia S3, nenhuma IAM Policy naquela conta pode liberar S3 — a SCP sempre vence.

> [!tip] 🔗 Conexão com o trabalho
> Você trabalha diariamente com o AWS Organizations da Corpay. As tasks de criação de contas para Zapay (PTSK0010372) passaram pelo portal Compass que interagiu com o AWS Organizations para criar novas contas-membro. Quando você precisou configurar acesso às contas ZPY-AI (DEV, QA, PRD), estava trabalhando com contas-membro dessa organização.
>
> O **Management Account** no seu ambiente é onde o IAM Identity Center fica configurado — por isso só quem tem acesso à management account consegue criar Permission Sets e Assignments para outras contas. Isso é exatamente o que a prova pergunta: *"Onde o IAM Identity Center deve ser configurado?"* → Na **Management Account**.
>
> **Analogia direta com Azure** (que você acabou de fazer hoje):
> - AWS Organizations ≈ Management Groups do Azure
> - SCPs ≈ Azure Policies
> - Management Account ≈ Tenant Root
> - Consolidated Billing ≈ Enterprise Agreement com fatura consolidada

### Consolidated Billing — Desconto por Volume

Com o faturamento consolidado, o consumo de todas as contas é somado para calcular o desconto:

- Se a conta A usa 5 TB de S3 e a conta B usa 10 TB → a organização inteira é cobrada pela faixa de 15 TB (que tem desconto maior)
- Reservations e Savings Plans **podem ser compartilhados** entre contas da org
