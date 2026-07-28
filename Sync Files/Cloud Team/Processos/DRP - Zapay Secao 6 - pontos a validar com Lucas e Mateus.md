---
tags: [trabalho, sem-parar, zapay, drp, aws, validação, pendência]
data: 2026-07-28
status: aguardando-validação
---

# DRP Zapay — Seção 6: pontos a validar com Lucas / Mateus

> [!info] Contexto
> Redigida a Seção 6 ("Visão geral dos ambientes computacionais") do DRP Sem Parar Doc, instanciada para o ambiente AWS da Zapay. Entregável: `~/Downloads/DRP_Zapay_Secao6_ambientes_computacionais.docx`.
>
> A redação foi baseada em **inventário documentado (junho/julho 2026)**, não em consulta ao vivo — a sessão SSO da Zapay estava expirada no momento da escrita. Antes de enviar ao Tibúrcio, revalidar via CLI e com o time.
>
> Ver também: [[DRP - Zapay v2.0 (débitos veiculares) - notas de trabalho]] · [[2026-06-16_zapay-account-disambiguation]] · [[ZPY - RDS zapay-db-production Instância standalone com read replica assíncrona]]

---

## 🚨 Contradição crítica — RDS Multi-AZ

Este é o ponto mais importante da validação, porque muda a postura de recuperação declarada no DRP.

| Fonte | Afirmação | Data |
|---|---|---|
| Mateus, na reunião semanal | "ambiente é resiliente — cluster multi-AZ, **RDS Multi-AZ**, Redis com réplica" | 2026-06-30 |
| Diagnóstico via `aws rds describe-db-instances` | `MultiAZ: false` em **ambas** as instâncias; sem `SecondaryAvailabilityZone`; resiliência apenas via **read replica assíncrona** cross-AZ, com promoção **manual** | 2026-07-07 |

A evidência de CLI contradiz o relato verbal. Uma read replica cross-AZ **não é** Multi-AZ — não há standby síncrono nem failover automático.

**Redigi a seção conforme a evidência de CLI** (item 6.5: "banco de dados sem failover automático"). Se o Mateus discordar, é preciso rodar o `describe-db-instances` junto com ele antes de mudar o texto — um DRP que declara failover automático inexistente é um achado de auditoria esperando para acontecer.

---

## ❓ Demais pontos a confirmar

| # | Ponto | O que está escrito | Por que validar |
|---|---|---|---|
| 1 | **Quantidade de clusters EKS** | Texto cita apenas `zapay-one` (prod) e `zpy-k8s-cluster-staging` | Na reunião de 2026-06-30 foi mencionado "**3 clusters separados: ferramentas, aplicações, staging**". O inventário de junho só listou um cluster em prod. Se existirem de fato 3, a seção 6.2 precisa listá-los. |
| 2 | **Vercel** | Descrito como hospedagem/entrega do front-end público | Info veio do Lucas verbalmente. Confirmar o escopo exato: só o site institucional? A aplicação do usuário final também? Isso muda o RTO — se o front está fora da AWS, um desastre na AWS não derruba o site, mas o derruba funcionalmente (sem back-end). |
| 3 | **Redis** | "camada de cache em memória utiliza Redis, com réplica configurada" | Relato do Mateus, não validado via CLI. Confirmar se é ElastiCache gerenciado ou self-hosted no cluster, e se a réplica é cross-AZ. |
| 4 | **Amazon MQ / RabbitMQ** | "cluster de três nós" | Baseado no incidente de rolagem de instância de 2026-06-30. Confirmar se a topologia se manteve após a rolagem (na época: 1 nó XLarge novo + 2 nós na versão anterior). |
| 5 | **MongoDB Atlas** | Citado entre os SaaS de terceiros | Confirmar se o Atlas atende o processo de **débitos veiculares** ou apenas o Olho no Carro — se for só ONC, sai do escopo desta seção. |
| 6 | **Cloudflare → Imperva** | "camada de proteção de borda (Cloudflare, em processo de migração para Imperva)" | Confirmar o estágio atual da migração — se já concluiu, ajustar o texto. |
| 7 | **Contas AWS listadas** | 7 contas na tabela do item 6.1 | Confirmar se `ZapayPayer` participa do fluxo de débitos veiculares e se a descrição "Serviços de pagamento" está correta. |
| 8 | **Distribuição de nós do EKS** | "nós distribuídos entre as Zonas de Disponibilidade" | O inventário de junho não listou managed nodegroups em prod (sugerindo Karpenter / self-managed / Fargate). Confirmar o modelo e se de fato há espalhamento entre as 3 AZs. |

---

## 🔁 Comandos para revalidar antes de enviar

```bash
aws sso login --profile zapay

aws sts get-caller-identity --profile zapay
aws eks list-clusters --region sa-east-1 --profile zapay
aws rds describe-db-instances --region sa-east-1 --profile zapay \
  --query "DBInstances[].{id:DBInstanceIdentifier,multiaz:MultiAZ,az:AvailabilityZone,engine:EngineVersion,class:DBInstanceClass}"
aws elasticache describe-replication-groups --region sa-east-1 --profile zapay
aws mq list-brokers --region sa-east-1 --profile zapay
aws ec2 describe-vpcs --region sa-east-1 --profile zapay \
  --query "Vpcs[].{id:VpcId,cidr:CidrBlock,name:Tags[?Key=='Name']|[0].Value}"
```

---

## 📌 Fluxo de aprovação

1. Felipe redige (**feito** — 2026-07-28)
2. Revalidar via CLI após `aws sso login`
3. Lucas e/ou Mateus validam o conteúdo técnico
4. Felipe envia ao Tibúrcio para incorporar ao DRP v2.x
