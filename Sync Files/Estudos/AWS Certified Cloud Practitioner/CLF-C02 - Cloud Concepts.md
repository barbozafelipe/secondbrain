
# CLF-C02 - Cloud Concepts
**Domínio 1 · 24% da prova**

Parte de: [[AWS Certified Cloud Practitioner]]

---

## ✅ Checklist de Estudo

- [ ] Value Proposition da Cloud (CapEx → OpEx, escala, elasticidade, velocidade)
- [ ] Modelos de serviço: IaaS, PaaS, SaaS
- [ ] Modelos de implantação: pública, híbrida, on-premises
- [ ] Well-Architected Framework — 6 pilares
- [ ] Estratégias de migração — 6 Rs
- [ ] AWS Cloud Adoption Framework (CAF) — 6 perspectivas
- [ ] Infraestrutura global: Regions, Availability Zones, Edge Locations
- [ ] Serviços de escopo global: CloudFront, Route 53, IAM, S3

---

## Value Proposition da Cloud

- **CapEx → OpEx**: troca de investimento fixo por custo variável sob demanda
- **Economia de escala**: AWS dilui custos entre milhões de clientes
- **Elasticidade**: escala para cima e para baixo conforme a demanda
- **Velocidade e agilidade**: provisionamento em minutos vs. semanas no data center

## Modelos de serviço

| Modelo | Você gerencia | AWS gerencia |
|--------|--------------|--------------|
| IaaS (EC2) | SO, runtime, app | Hardware, rede |
| PaaS (Elastic Beanstalk) | Código | Tudo abaixo |
| SaaS (WorkMail) | Dados | Tudo |

## Modelos de implantação

- **Cloud pública** — 100% AWS
- **Híbrida** — on-premises + AWS (Direct Connect / VPN)
- **On-premises / Private Cloud** — OpenStack, VMware no próprio DC

## AWS Well-Architected Framework — 6 Pilares

1. **Operational Excellence** — automação, runbooks, melhoria contínua
2. **Security** — least privilege, criptografia em trânsito e em repouso
3. **Reliability** — recuperação de falhas, redundância, backups
4. **Performance Efficiency** — escolha certa de recursos, serverless
5. **Cost Optimization** — evitar gasto desnecessário, right-sizing
6. **Sustainability** — minimizar impacto ambiental das cargas

## Estratégias de migração (6 Rs)

| R | Estratégia |
|---|-----------|
| Rehost | Lift-and-shift — move sem alterar |
| Replatform | Pequenas otimizações (ex: RDS no lugar de MySQL manual) |
| Repurchase | Trocar por SaaS (ex: Salesforce) |
| Refactor | Re-arquitetar para cloud-native |
| Retire | Descomissionar o que não é mais necessário |
| Retain | Manter on-premises por ora |

## AWS Cloud Adoption Framework (CAF)

6 perspectivas: Business, People, Governance, Platform, Security, Operations

## Infraestrutura Global AWS

- **Region**: área geográfica com 2+ AZs (ex: us-east-1)
- **Availability Zone (AZ)**: 1 ou mais datacenters isolados dentro de uma Region
- **Edge Location**: ponto de presença para CDN (CloudFront) e DNS (Route 53)
- **Local Zone**: extensão de Region mais próxima do usuário final para baixa latência
