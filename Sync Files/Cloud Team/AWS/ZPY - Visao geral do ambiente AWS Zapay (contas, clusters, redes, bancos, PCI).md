---
tags: [aws, zapay, inventario, eks, rds, pci, referencia]
date: 2026-07-28
account: "múltiplas contas Zapay (ver tabela)"
status: validado-via-cli
---

# ZPY - Visão geral do ambiente AWS Zapay (contas, clusters, redes, bancos, PCI)

## Contexto

Inventário consolidado do ambiente AWS que suporta a plataforma Zapay, levantado para instanciar a Seção 6 ("Visão geral dos ambientes computacionais") do [[DRP - Zapay v2.0 (débitos veiculares) - notas de trabalho|DRP Sem Parar Doc]], mas útil como referência geral do ambiente para qualquer diagnóstico futuro (humano ou IA).

**Todos os dados abaixo foram validados via AWS CLI em 2026-07-28** (sessão SSO `zapay`, perfis `zapay`, `zapay-staging-sso` e perfis adicionais para Tools/Payment/Monitoring), e complementados com o retorno técnico do Mateus (time de Cloud/Devops da Zapay) na mesma data.

Ver também: [[2026-06-16_zapay-account-disambiguation]] · [[ZPY - RDS zapay-db-production Instância standalone com read replica assíncrona]] · [[DRP - Zapay Secao 6 - pontos a validar com Lucas e Mateus]]

---

## Organização AWS e contas

A Zapay mantém organização própria no AWS Organizations (sessão SSO `zapay`, `https://d-946773ab8e.awsapps.com/start/#`, role `BR_PSAWSZPY_CLOUD`). Contas relevantes ao ambiente de produção e plataforma:

| Conta | ID | Finalidade | Região principal |
|---|---|---|---|
| **Zapay** | 071032557399 | Produção real: cluster Kubernetes, bancos de dados, aplicações | sa-east-1 |
| **Payment** | 831926599670 | Ambiente segregado de pagamentos, escopo **PCI** | sa-east-1 |
| **Tools** | 148761638451 | Ferramentas de plataforma compartilhadas (ArgoCD, Vault, runners, GrowthBook etc.) | us-east-2 |
| **zapay-staging** | 901943060028 | Homologação / staging | us-east-2 |
| **zapay-production** | 717354774649 | Landing zone para futura migração de workloads; sem carga de trabalho hoje | sa-east-1 |
| **ZapayPayer** | 575108926897 | Serviços de pagamento (distinta de Payment/PCI; diferença exata a confirmar) | sa-east-1 |
| **Audit** | 242201304053 | Governança e auditoria | sa-east-1 |
| **Log Archive** | 183295435188 | Retenção centralizada de logs | sa-east-1 |
| **Monitoring** | 976193234625 | Service desk (GLPI); sem carga de trabalho relevante | us-east-2 |
| **Olho no Carro** | 865350113542 | Produto ONC, ambiente próprio, fora do escopo de débitos veiculares | sa-east-1 |

> [!warning] Lição de método
> Um inventário anterior (2026-06-16) excluiu Tools e Payment do "perímetro Zapay" por convenção, por parecerem contas "Corpay". Isso levou a uma conclusão errada (achar que só havia 1 cluster EKS, quando há 3). **Nomes de conta e convenções de perímetro não substituem validação real de acesso e conteúdo** — sempre confirmar com `aws sts get-caller-identity` e inventariar antes de excluir uma conta do escopo.

---

## Clusters Kubernetes (Amazon EKS)

Três clusters, todos Kubernetes **v1.34**, todos com endpoint da API **sem exposição pública** (acesso privado apenas, alcançável só de dentro da respectiva VPC):

| Cluster | Finalidade | Conta / Região | VPC | Nós ativos |
|---|---|---|---|---|
| **zapay-one** | Produção — aplicações e APIs Zapay | Zapay / sa-east-1 | EKS-VPC (192.168.0.0/16) | 73 |
| **zpy-platform-tools** | Ferramentas de plataforma (compartilhado) | Tools / us-east-2 | vpc-tools (10.50.0.0/16) | 13 |
| **zpy-k8s-cluster-staging** | Homologação / staging | zapay-staging / us-east-2 | vpc-staging (10.200.0.0/16) | — |

### zapay-one (produção)

- 73 nós EC2, distribuídos: sa-east-1a = 27, sa-east-1b = 13, sa-east-1c = 33.
- Sub-redes: `subnet-0e3c227b323c15a83` (1a, 192.168.64.0/18), `subnet-0619f0ddf80b2982d` (1b, 192.168.128.0/18), `subnet-0a801c389444e122e` (1c, 192.168.192.0/18).
- **Sem managed nodegroups nativos da AWS.** O provisionamento e dimensionamento dos nós é feito pelo **Spot.io (Spotinst Ocean)** — confirmado pelas tags `spotinst:aws:ec2:group:*` presentes nas instâncias.
- Publicação de serviços via ALB/NLB, distribuídos nas 3 AZs, com segregação entre balanceadores internos e de exposição à internet.

### zpy-platform-tools (ferramentas, conta Tools)

Hospeda serviços de apoio à engenharia que atendem **toda a plataforma Zapay**, não um produto específico:

- **ArgoCD** — esteira de implantação contínua (GitOps) das aplicações. Confirmado pelo Mateus como o mecanismo real de provisionamento dos serviços; **deve compor o escopo de qualquer teste de recuperação de desastres**, já que a produção depende dele para reimplantar aplicações.
- **HashiCorp Vault** + **Dex** (autenticação).
- **OpenMetadata** (catálogo de dados).
- **DevLake** (métricas de engenharia).
- **GitHub Actions runners** compartilhados (distintos dos runners EC2 dedicados que existem na própria conta Zapay).
- **GrowthBook** (feature flags), confirmado pelo Mateus como app hospedado nesse cluster.

Bancos de dados da conta Tools: `zpy-db-tools` (PostgreSQL 16.13, db.t4g.micro) e `devlake-tools` (Aurora MySQL 8.0, db.t4g.medium) — ambos **sem Multi-AZ**, região us-east-2c. `devlake-tools` tem retenção de backup de apenas 1 dia.

Nós do cluster por AZ: us-east-2a = 1, us-east-2b = 6, us-east-2c = 6.

### zpy-k8s-cluster-staging (homologação)

VPC `vpc-02908c26893436ced` (10.200.0.0/16), nodegroup `temp-stg-node-group`.

---

## Redes virtuais (VPCs)

**Conta Zapay (produção):**

| VPC | CIDR | Uso |
|---|---|---|
| vpc-0e1fc1d6b0cbbaa6d (EKS-VPC) | 192.168.0.0/16 | Cluster e bancos de dados |
| vpc-015a78c4b0b5dc771 (DMSVPC) | 10.0.0.0/16 | Replicação e migração de dados |
| vpc-0616fb61 (GENERAL) | 172.31.0.0/16 | Padrão |

**Conta Tools:** `vpc-tools` (10.50.0.0/16), us-east-2 — hospeda o cluster de ferramentas.

**Conta Payment:** `zpy-payment-pci-proxy-vpc` (10.10.0.0/16), sa-east-1 — ver seção PCI abaixo.

---

## Banco de dados (Amazon RDS, engine PostgreSQL)

| Instância | Versão | Classe | AZ | Multi-AZ | Backup |
|---|---|---|---|---|---|
| zapay-db-production | 16.14 | db.m6g.4xlarge | sa-east-1c | **Não** | 7 dias |
| zapay-db-production-replica | 16.14 | db.m6g.2xlarge | sa-east-1a | **Não** (réplica assíncrona) | 0 (réplica) |
| zapay-api-homologation | 16.13 | db.t4g.medium | sa-east-1c | Não | 7 dias |
| midgard | 16.13 | db.t4g.small | sa-east-1c | Não | 7 dias |
| zpy-customer-communication-cms-strapi | 14.22 | db.t3.medium | sa-east-1b | **Sim** (secundária 1a) | 7 dias |

Todas com criptografia em repouso (KMS), deletion protection habilitada, sem exposição pública.

> [!warning] Zapay-db-production NÃO é Multi-AZ
> Contradiz relato verbal da reunião de 2026-06-30 ("RDS Multi-AZ"). Confirmado via `describe-db-instances` em duas datas (2026-07-07 e 2026-07-28): `MultiAZ: false`, sem `SecondaryAvailabilityZone`. A resiliência vem apenas da read replica assíncrona cross-AZ, com promoção manual em caso de desastre. Ironicamente, a única base Multi-AZ do ambiente é o CMS Strapi (não crítico).

## Cache e mensageria

- **ElastiCache Redis**: dois grupos de replicação, `zpy-redis-prod` e `zpy-redis-api`, **ambos Multi-AZ com failover automático habilitado**.
- **Amazon MQ (RabbitMQ)**: broker `zpy-cluster-rabbitmq-prod`, modo **CLUSTER_MULTI_AZ**.

---

## Ambiente segregado de pagamentos (escopo PCI) — conta Payment

- VPC dedicada `zpy-payment-pci-proxy-vpc` (10.10.0.0/16), sa-east-1, 6 sub-redes nas 3 AZs, nenhuma com IP público automático.
- **Sem VPC peering e sem Transit Gateway** — rede isolada das demais.
- **Zero EC2, zero RDS, zero load balancers.** Carga de trabalho 100% serverless:
  - API Gateway REST `PaymentGatewayAPI`
  - Lambda `zpy-payment-pci-proxy` (512 MB, timeout 30s, x86_64)
- Superfície de recuperação mínima por design.

---

## Backup (AWS Backup)

| Plano | Recurso | Agenda | Retenção | Cofre | Cópia cross-region |
|---|---|---|---|---|---|
| RDSBackupPlan1 | RDS | Diária, 03h30 (cron) | 7 dias | RDSVault | Nenhuma |
| S3BackupPlan1 | S3 | Mensal, dia 1º | 7 dias | S3Vault | Nenhuma |
| DynamoBackupPlan1 | DynamoDB | — | — | — | — |

> [!warning] Sem cópia de backup para outra região
> Todos os cofres residem em sa-east-1, a mesma região da produção. Uma perda de região leva o ambiente e os backups juntos. Provavelmente o maior gap de recuperação identificado no ambiente.

---

## VPN de acesso

4 endpoints AWS Client VPN ativos em sa-east-1, todos com split tunnel:

| Endpoint | CIDR de clientes | Autenticação |
|---|---|---|
| cvpn-endpoint-0bedaba638b574804 | 10.0.0.0/22 | Federada (SSO) |
| cvpn-endpoint-0aba517ba85a9b782 | 10.1.0.0/22 | Federada (SSO) |
| cvpn-endpoint-0e247893b18c1889a | 172.16.0.0/12 | Federada (SSO) |
| cvpn-endpoint-0d6dbb4ae277b4681 | 20.0.0.0/22 | Certificado |

Perfil de configuração usado pelos colaboradores: `zpy-vpn-prod`, provisionado via portal **VPN Client Self Service** no AWS access portal (procedimento interno "Acesso AWS VPN Client Engenharia").

Autenticação de acesso ao ambiente em geral: **AWS IAM Identity Center (SSO)**, com permission sets por função/área. Dentro do cluster: **RBAC** (autorização) e **IRSA** (aplicações autenticam nos serviços AWS sem credenciais estáticas).

---

## EC2 fora dos clusters (conta Zapay)

| Nome | Tipo | AZ | Observação |
|---|---|---|---|
| API DETRAN Sergipe | t2.micro | sa-east-1a | Integração com órgão de trânsito; instância única |
| API Detran SE Gringo | t2.micro | sa-east-1a | |
| Daycoval-Principal | t3.small | sa-east-1c | |
| Daycoval-Contingencia | t3.small | **sa-east-1c** | Mesma AZ da principal — sem isolamento de zona |
| Daycoval-homolog | t3.small | sa-east-1a | |
| Gringo-Daycoval-Principal | t3.small | sa-east-1c | |
| Gringo-Daycoval-Contingencia | t3.small | **sa-east-1c** | Mesma AZ da principal |
| Production Nginx | t3.xlarge | sa-east-1a | Proxy reverso |
| runner-githubactions-* (3 instâncias) | t3a.xlarge / t2.xlarge | 1a, 1b | Runners próprios da Zapay, distintos dos compartilhados em Tools |

---

## Serviços de terceiros (fora do perímetro AWS)

- **Vercel** — hospedagem e entrega do front-end (site e aplicação web do usuário final).
- **Spot.io (Spotinst Ocean)** — provisionamento e dimensionamento dos nós do cluster de produção.
- **MongoDB Atlas** — a confirmar se atende débitos veiculares ou só Olho no Carro.
- **Cloudflare** — camada de borda, em processo de migração para **Imperva**.

---

## Pontos em aberto (a confirmar com o time)

1. Diferença exata entre a conta **ZapayPayer** (575108926897) e **Payment** (831926599670, escopo PCI).
2. Se o **MongoDB Atlas** atende débitos veiculares ou só Olho no Carro.
3. Se **Daycoval** (principal/contingência na mesma AZ) está no caminho crítico de débitos veiculares.
4. Estágio atual da migração Cloudflare → Imperva.
5. Dependência do ArgoCD no `zpy-db-tools` (sem Multi-AZ, backup relevante para a esteira de implantação).

---

## Comandos de referência

```bash
aws sso login --profile zapay

aws sts get-caller-identity --profile zapay
aws eks list-clusters --region sa-east-1 --profile zapay
aws eks describe-cluster --name zapay-one --region sa-east-1 --profile zapay \
  --query "cluster.{ver:version,vpc:resourcesVpcConfig.vpcId,pub:resourcesVpcConfig.endpointPublicAccess}"

aws rds describe-db-instances --region sa-east-1 --profile zapay \
  --query "DBInstances[].{id:DBInstanceIdentifier,multiaz:MultiAZ,az:AvailabilityZone}"

aws elasticache describe-replication-groups --region sa-east-1 --profile zapay
aws mq list-brokers --region sa-east-1 --profile zapay
aws ec2 describe-client-vpn-endpoints --region sa-east-1 --profile zapay
aws backup list-backup-plans --region sa-east-1 --profile zapay
aws elbv2 describe-load-balancers --region sa-east-1 --profile zapay

# Contas adicionais (Tools, Payment, Monitoring) exigem perfis próprios
# com sso_session = zapay e o respectivo sso_account_id
```

## Referências

- Documento de origem: `PR_DRP_001_B2C - Plano de Recuperação de Desastres SEM PARAR DOC 20260702 v2.0 1.pdf` (Tibúrcio, 2026-07-27)
- Entregável gerado a partir deste inventário: `DRP_Zapay_Secao6_ambientes_computacionais.docx`
- Validação técnica: Mateus e Lucas (time Cloud/Devops Zapay), 2026-07-28
