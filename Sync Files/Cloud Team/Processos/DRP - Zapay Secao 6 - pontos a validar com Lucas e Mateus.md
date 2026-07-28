---
tags: [trabalho, sem-parar, zapay, drp, aws, validação, inventário]
data: 2026-07-28
status: validado-via-cli-e-time
---

> [!success] Retorno do Mateus (2026-07-28)
> Confirmou a inclusão de Payment (infra avaliada pelo PCI) e Tools (runners, GrowthBook, outros apps compartilhados da plataforma Zapay como um todo). Apontou que o texto só listava as VPCs da conta principal, faltando deixar claro que Payment e Tools também têm VPC própria ativa. Validou banco, cache e mensageria sem ressalvas. Confirmou que o ArgoCD é usado para provisionamento dos serviços e que, por isso, deve compor o escopo de um teste de recuperação. Tudo incorporado na revisão de 2026-07-28 (documento agora com 6.1–6.7, VPCs de Tools e Payment explicitadas, GrowthBook e runners compartilhados mencionados no 6.2, e o ponto do ArgoCD reforçado no 6.7).

# DRP Zapay — Seção 6: inventário validado e pontos para Lucas / Mateus

> [!info] Contexto
> Redigida a Seção 6 ("Visão geral dos ambientes computacionais") do DRP Sem Parar Doc, instanciada para o ambiente AWS da Zapay. Entregável: `~/Downloads/DRP_Zapay_Secao6_ambientes_computacionais.docx` (5 páginas).
>
> **Todos os dados foram validados via AWS CLI em 2026-07-28**, conta `071032557399` (Zapay prod), região `sa-east-1`.
>
> Ver também: [[DRP - Zapay v2.0 (débitos veiculares) - notas de trabalho]] · [[DRP - Metodologia BIA-PCN-DRP (SPDOCS)]] · [[2026-06-16_zapay-account-disambiguation]] · [[ZPY - Visao geral do ambiente AWS Zapay (contas, clusters, redes, bancos, PCI)]]

---

## ✅ Inventário confirmado (2026-07-28)

### Cluster Kubernetes

> [!warning] Correção de 2026-07-28 (após retorno do Lucas)
> A primeira varredura só cobriu as contas `zapay` e `zapay-staging`, porque o inventário de junho havia classificado **Tools** e **Payment** como "fora do perímetro" (contas Corpay). O Lucas corrigiu: **são contas da Zapay e estão no escopo**. Com elas, os "3 clusters" da reunião de 30/06 **se confirmam**.

**Três clusters EKS, todos v1.34, todos com endpoint da API sem exposição pública:**

| Cluster | Finalidade | Conta / Região | VPC | Nós |
|---|---|---|---|---|
| `zapay-one` | Produção | Zapay (071032557399) / sa-east-1 | EKS-VPC 192.168.0.0/16 | 73 |
| `zpy-platform-tools` | Ferramentas | Tools (148761638451) / **us-east-2** | vpc-tools 10.50.0.0/16 | 13 |
| `zpy-k8s-cluster-staging` | Staging | zapay-staging (901943060028) / us-east-2 | vpc-staging 10.200.0.0/16 | — |

**Ferramentas rodando no `zpy-platform-tools`** (confirmadas pelos ALBs internos): **ArgoCD** (`k8s-argocd-argocdse-*` — esteira GitOps), **HashiCorp Vault** + **Dex** (`k8s-vault-vaulttoo-*`, `k8s-vault-dex-*`), **OpenMetadata**, **DevLake**, ingress-nginx e `zpy-growth`. Bancos da conta Tools: `zpy-db-tools` (PostgreSQL 16.13, t4g.micro) e `devlake-tools` (Aurora MySQL 8.0, t4g.medium) — ambos **sem Multi-AZ**, em us-east-2c.

Nós do cluster de ferramentas por AZ: us-east-2a = 1, us-east-2b = 6, us-east-2c = 6.

### Conta Payment (831926599670) — escopo PCI

- VPC dedicada **`zpy-payment-pci-proxy-vpc`** (10.10.0.0/16), sa-east-1, **6 sub-redes** nas 3 AZs (3 "Private" + 3 "Publica", mas **todas** com `MapPublicIpOnLaunch: false`).
- **Sem VPC peering e sem Transit Gateway attachment** — rede isolada.
- **Zero EC2, zero RDS, zero load balancers.** Carga de trabalho integralmente serverless:
  - **API Gateway REST** `PaymentGatewayAPI` (id `nl6tw7442a`)
  - **Lambda** `zpy-payment-pci-proxy` — 512 MB, timeout 30s, x86_64, associada às 3 sub-redes privadas. Última modificação: 2025-09-19.
- Boa notícia para o DRP: escopo PCI minimizado e superfície de recuperação pequena.

### Conta Monitoring (976193234625)

Sem EKS. Apenas 2 EC2 e um LB `suporte-glpi` em us-east-2 — service desk, fora do caminho crítico de débitos veiculares.
- **73 nós EC2 ativos**, distribuídos: `sa-east-1a` = 27, `sa-east-1b` = 13, `sa-east-1c` = 33.
- **Zero managed nodegroups, zero Fargate profiles** — os nós são gerenciados pelo **Spot.io / Spotinst Ocean** (confirmado pelas tags `spotinst:aws:ec2:group:*` nas instâncias e pelos nomes de sub-rede `spotinst-eks-stack-Subnet0X`).
- Endpoint da API do cluster: **público desabilitado, privado habilitado** — só alcançável de dentro da VPC. Isso justifica tecnicamente a obrigatoriedade da VPN.
- Sub-redes: `subnet-0e3c227b323c15a83` (1a, 192.168.64.0/18), `subnet-0619f0ddf80b2982d` (1b, 192.168.128.0/18), `subnet-0a801c389444e122e` (1c, 192.168.192.0/18).

### Banco de dados (RDS PostgreSQL)

| Instância | Versão | Classe | AZ | Multi-AZ | Backup |
|---|---|---|---|---|---|
| zapay-db-production | 16.14 | db.m6g.4xlarge | sa-east-1c | **Não** | 7 dias |
| zapay-db-production-replica | 16.14 | db.m6g.2xlarge | sa-east-1a | **Não** | 0 (réplica) |
| zapay-api-homologation | 16.13 | db.t4g.medium | sa-east-1c | Não | 7 dias |
| midgard | 16.13 | db.t4g.small | sa-east-1c | Não | 7 dias |
| zpy-customer-communication-cms-strapi | 14.22 | db.t3.medium | sa-east-1b | **Sim** (sec. 1a) | 7 dias |

Todas criptografadas (KMS), sem exposição pública, com deletion protection.

### Cache, mensageria e balanceadores

- **ElastiCache Redis**: dois grupos de replicação — `zpy-redis-prod` e `zpy-redis-api` — **ambos Multi-AZ com failover automático habilitado**, 2 nós cada.
- **Amazon MQ**: broker `zpy-cluster-rabbitmq-prod`, RabbitMQ, RUNNING, modo **CLUSTER_MULTI_AZ**.
- **Load balancers**: todos os ALB/NLB inspecionados abrangem as 3 AZs. Namespaces visíveis nos nomes incluem `zpyvehic` (débitos veiculares — inclusive um `zpyvehic-orchestr` interno, provável Orquestrador ZAPI), `zpycusto`, `zpyplatf`, `zpyenter`, `detran-df-lb` (interno) e `vault`.

### Backup

| Plano | Recurso | Agenda | Retenção | Cofre | Cópia cross-region |
|---|---|---|---|---|---|
| RDSBackupPlan1 | RDS | `cron(30 3 ? * * *)` — diária 03h30 | 7 dias | RDSVault | **Nenhuma** |
| S3BackupPlan1 | S3 | `cron(30 0 1 * ? *)` — mensal dia 1º | 7 dias | S3Vault | **Nenhuma** |
| DynamoBackupPlan1 | DynamoDB | — | — | — | — |

`zapay-db-production` tinha 8 snapshots automáticos no momento da consulta.

### VPN

Quatro endpoints AWS Client VPN ativos em `sa-east-1`, todos com split tunnel:

| Endpoint | CIDR de clientes | Autenticação |
|---|---|---|
| cvpn-endpoint-0bedaba638b574804 | 10.0.0.0/22 | federated (SSO) |
| cvpn-endpoint-0aba517ba85a9b782 | 10.1.0.0/22 | federated (SSO) |
| cvpn-endpoint-0e247893b18c1889a | 172.16.0.0/12 | federated (SSO) |
| cvpn-endpoint-0d6dbb4ae277b4681 | 20.0.0.0/22 | **certificate** |

### EC2 fora do cluster (14 instâncias)

| Nome | Tipo | AZ |
|---|---|---|
| API DETRAN Sergipe | t2.micro | sa-east-1a |
| API Detran SE Gringo | t2.micro | sa-east-1a |
| Daycoval-Principal | t3.small | sa-east-1c |
| Daycoval-Contingencia | t3.small | **sa-east-1c** |
| Daycoval-homolog | t3.small | sa-east-1a |
| Gringo-Daycoval-Principal | t3.small | sa-east-1c |
| Gringo-Daycoval-Contingencia | t3.small | **sa-east-1c** |
| Production Nginx | t3.xlarge | sa-east-1a |
| dyna-config | t3.small | sa-east-1b |
| ec2-access-vpn-sanhkya | t2.micro | sa-east-1a |
| ec2-kondado-sep | t3.nano | sa-east-1a |
| runner-githubactions-api / -api-2 / -app | t3a.xlarge / t2.xlarge | 1a, 1b, 1a |

---

## 🚩 Achados que valem discussão com o time

### 1. Contradição resolvida — RDS **não** é Multi-AZ

Na reunião semanal de 2026-06-30, Mateus reportou "cluster multi-AZ, **RDS Multi-AZ**, Redis com réplica". A CLI confirma (em 2026-07-07 e novamente em 2026-07-28) que `zapay-db-production` tem `MultiAZ: false`, sem `SecondaryAvailabilityZone`. A resiliência vem de uma **read replica assíncrona** cross-AZ, cuja promoção é **manual**.

Ironia do inventário: a única base Multi-AZ do ambiente é a `zpy-customer-communication-cms-strapi` (CMS), que não é crítica — enquanto a base principal do processo crítico não é.

Mateus estava certo sobre **Redis** (Multi-AZ + failover automático) e sobre o **cluster** (3 AZs). O ponto do RDS é o que não se sustenta.

### 2. "3 clusters separados" — CONFIRMADO

A reunião de 30/06 mencionou "3 clusters separados: ferramentas, aplicações, staging". **Confirmado**, uma vez incluída a conta Tools. A lição de método: o inventário de junho excluiu Tools/Payment por convenção de perímetro, e isso produziu uma conclusão errada. Contas "Corpay" nessa organização podem, sim, ser da Zapay — validar caso a caso, não por nome.

### 2b. Esteira de implantação em outra região

O **ArgoCD** vive em us-east-2 (conta Tools), enquanto a produção está em sa-east-1. Isso é favorável num cenário de indisponibilidade regional da produção (a esteira sobrevive), mas cria dependência cruzada: reimplantar aplicações exige que **duas contas e duas regiões** estejam saudáveis. Vale discutir no plano de teste de DR.

### 3. Contingência do Daycoval na mesma AZ da principal

`Daycoval-Principal` e `Daycoval-Contingencia` estão **ambas em sa-east-1c** (o mesmo vale para o par do Gringo). Uma falha de AZ derruba principal e contingência juntas. Pode ser intencional (contingência de aplicação, não de infraestrutura), mas para um DRP é um ponto que precisa de resposta.

### 4. Backups sem cópia para outra região

Nenhum dos planos do AWS Backup tem `CopyActions`. Os cofres vivem em `sa-east-1` — a mesma região do ambiente produtivo. Num cenário de perda de região, os backups se perdem junto. Esse é provavelmente o gap mais relevante do ambiente para fins de DR.

### 5. Servidores de integração DETRAN como ponto único

`API DETRAN Sergipe` é uma instância `t2.micro` única, em AZ única. As integrações DETRAN/SENATRAN estão listadas como sistema crítico no item 6.2 do DRP.

---

## ❓ Ainda a confirmar com Lucas / Mateus

| # | Ponto | Por quê |
|---|---|---|
| 1 | Escopo real da **Vercel** | Só site institucional ou a aplicação do usuário final? Muda o entendimento do RTO — o front pode continuar no ar com o back-end fora. |
| 2 | **MongoDB Atlas** atende débitos veiculares ou só o ONC? | Se for só ONC, sai do escopo desta seção. |
| 3 | Estágio da migração **Cloudflare → Imperva** | Ajustar o texto se já concluiu. |
| 4 | **ZapayPayer** (575108926897) participa do fluxo de débitos veiculares? | A descrição "Serviços de pagamento" na tabela 6.1 é suposição — e agora convive com a conta **Payment**, que é a de escopo PCI. Confirmar a diferença entre as duas. |
| 7 | Bancos da conta **Tools** sem Multi-AZ e backup de 1 dia (`devlake-tools`) | Se o ArgoCD depende do `zpy-db-tools`, a perda dessa base afeta a esteira de implantação. |
| 5 | **Daycoval** está no caminho crítico de débitos veiculares? | Determina se entra na seção ou se é escopo de outro processo. |
| 6 | Dependência do **Spot.io** | Confirmar se uma indisponibilidade do Spot.io impede o escalonamento/substituição de nós. |

---

## 🔁 Comandos usados

```bash
aws sso login --profile zapay

aws eks list-clusters --region sa-east-1 --profile zapay
aws eks describe-cluster --name zapay-one --region sa-east-1 --profile zapay \
  --query "cluster.{ver:version,vpc:resourcesVpcConfig.vpcId,subnets:resourcesVpcConfig.subnetIds,pub:resourcesVpcConfig.endpointPublicAccess}"
aws eks list-nodegroups --cluster-name zapay-one --region sa-east-1 --profile zapay

aws rds describe-db-instances --region sa-east-1 --profile zapay \
  --query "DBInstances[].{id:DBInstanceIdentifier,multiaz:MultiAZ,az:AvailabilityZone,secondaryAz:SecondaryAvailabilityZone}"

aws elasticache describe-replication-groups --region sa-east-1 --profile zapay
aws mq list-brokers --region sa-east-1 --profile zapay
aws ec2 describe-client-vpn-endpoints --region sa-east-1 --profile zapay
aws backup list-backup-plans --region sa-east-1 --profile zapay
aws backup get-backup-plan --backup-plan-id <id> --region sa-east-1 --profile zapay
aws elbv2 describe-load-balancers --region sa-east-1 --profile zapay
```

---

## 📌 Fluxo de aprovação

1. Felipe redige — **feito** (2026-07-28)
2. Validação via CLI — **feito** (2026-07-28)
3. Lucas e/ou Mateus validam o conteúdo técnico — *pendente*
4. Felipe envia ao Tibúrcio para incorporar ao DRP v2.x — *pendente*
