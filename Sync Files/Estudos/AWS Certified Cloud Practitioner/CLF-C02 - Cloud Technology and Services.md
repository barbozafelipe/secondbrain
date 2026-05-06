
# CLF-C02 - Cloud Technology and Services

**Domínio 3 · 34% da prova** | Parte de: [[AWS Certified Cloud Practitioner]]

---

## 🔔 Lembrete 2 — Revisar Cloud Technology & Services

**Data:** 21/05/2026 (Qui) · 16h | ⏱️ Tempo estimado: 60 min *(domínio mais pesado)*

> [!info] Primeiro passo (2 min)
> Abra o checklist de **Computação** abaixo. ECS, EKS, Lambda — você usa isso no dia a dia na Sem Parar. Comece pelos serviços que já conhece e marque como revisados. O movimento inicial é o mais importante.

> [!success] Ao terminar esta sessão
> Você terá coberto **88% do peso total da prova** (24% + 30% + 34%). Faltará apenas o Billing para completar 100% do conteúdo.

---

## ✅ Checklist de Estudo

**Computação**
- [ ] EC2: tipos de instância, famílias (C, M, R, T), AMIs, estados
- [ ] Lambda — serverless, event-driven, cobrança por invocação
- [ ] ECS e EKS — orquestração de containers
- [ ] Fargate — containers serverless (sem gerenciar nodes)
- [ ] Elastic Beanstalk — PaaS para deploy de aplicações

**Armazenamento**
- [ ] S3: classes (Standard, IA, Glacier), versionamento, lifecycle, ACLs
- [ ] EBS — block storage persistente para EC2
- [ ] EFS — file system gerenciado e compartilhado (NFS)
- [ ] S3 Glacier e Glacier Deep Archive — arquivamento de longo prazo
- [ ] AWS Storage Gateway e AWS Backup

**Banco de dados**
- [ ] RDS e Aurora — relacionais gerenciados (MySQL, PostgreSQL, Oracle...)
- [ ] DynamoDB — NoSQL serverless, chave-valor
- [ ] Redshift — data warehouse para analytics
- [ ] ElastiCache — cache em memória (Redis e Memcached)
- [ ] DocumentDB (MongoDB-compatible) e Neptune (grafo)

**Rede**
- [ ] VPC: subnets públicas/privadas, route tables, Internet Gateway
- [ ] Security Groups (stateful) vs NACLs (stateless)
- [ ] Route 53 — DNS gerenciado, roteamento de tráfego
- [ ] CloudFront — CDN global com Edge Locations
- [ ] Direct Connect — conexão dedicada on-premises ↔ AWS
- [ ] VPN Site-to-Site — túnel criptografado via internet
- [ ] Elastic Load Balancing: ALB (camada 7), NLB (camada 4)

**Monitoramento e gerenciamento**
- [ ] CloudWatch — métricas, logs, alarmes, dashboards
- [ ] CloudTrail — auditoria de chamadas de API (quem fez o quê)
- [ ] AWS Config — histórico e conformidade de configuração de recursos
- [ ] Systems Manager (SSM) — operação e automação de frota
- [ ] Trusted Advisor — recomendações de custo, segurança, desempenho
- [ ] AWS Health Dashboard — status dos serviços e impacto na sua conta

**Integração e mensageria**
- [ ] SQS — fila de mensagens desacoplada (pull)
- [ ] SNS — notificações pub/sub (push)
- [ ] EventBridge — barramento de eventos entre serviços
- [ ] Step Functions — orquestração de workflows serverless

**Analytics e IA/ML**
- [ ] Athena — queries SQL diretamente no S3 (serverless)
- [ ] Glue — ETL gerenciado e catálogo de dados
- [ ] Kinesis — ingestão e processamento de dados em streaming
- [ ] SageMaker — plataforma de ML gerenciada (treinar, implantar)
- [ ] Serviços de IA pré-treinados: Rekognition, Polly, Translate, Lex, Comprehend

**Migração**
- [ ] AWS Migration Hub e Database Migration Service (DMS)
- [ ] Snow Family: Snowcone, Snowball Edge, Snowmobile
- [ ] Application Migration Service (MGN) — lift-and-shift automatizado

**Developer Tools**
- [ ] CodeCommit, CodeBuild, CodeDeploy, CodePipeline — CI/CD na AWS

---

## Computação

### EC2 — Elastic Compute Cloud
- Instâncias virtuais com escolha de CPU, RAM, SO e rede
- **Famílias**: T (uso geral, burstable), M (balanceado), C (compute-optimized), R (memory-optimized)
- **AMI** (Amazon Machine Image): template de SO + software para lançar instâncias

### Lambda
- Executa código sem provisionar servidores
- Cobrado por número de invocações e duração (ms)
- Integra com S3, DynamoDB, API Gateway, EventBridge etc.

### Containers
| Serviço | O que é |
|---|---|
| **ECS** | Orquestrador de containers próprio da AWS |
| **EKS** | Kubernetes gerenciado na AWS |
| **Fargate** | Engine serverless para ECS/EKS — sem gerenciar nodes |

### Elastic Beanstalk
- PaaS: você sobe o código, AWS cuida de EC2, LB, Auto Scaling, monitoramento

---

## Armazenamento

### S3 — Simple Storage Service
- Object storage: armazena qualquer arquivo como objeto em buckets
- **Classes de armazenamento**:

| Classe | Uso |
|---|---|
| Standard | Acesso frequente |
| Standard-IA | Acesso infrequente, recuperação rápida |
| One Zone-IA | IA em 1 AZ (menor resiliência) |
| Glacier Instant | Arquivamento com acesso em ms |
| Glacier Flexible | Arquivamento, acesso em minutos/horas |
| Glacier Deep Archive | Arquivamento máximo, acesso em horas |
| Intelligent-Tiering | Move automaticamente entre tiers |

### EBS — Elastic Block Store
- Volumes de disco persistentes para EC2 (como HD externo)
- Tipos: gp3 (uso geral), io2 (alta IOPS), st1 (throughput), sc1 (frio)

### EFS — Elastic File System
- File system compartilhado via NFS — múltiplas instâncias EC2 ao mesmo tempo

---

## Banco de Dados

| Serviço | Tipo | Caso de uso |
|---|---|---|
| **RDS** | Relacional gerenciado | MySQL, PostgreSQL, Oracle, SQL Server |
| **Aurora** | Relacional cloud-native | Alta performance, até 5× mais rápido que MySQL |
| **DynamoDB** | NoSQL chave-valor | Alta escala, serverless, milissegundos |
| **Redshift** | Data warehouse | Analytics em petabytes de dados |
| **ElastiCache** | Cache in-memory | Redis/Memcached para acelerar aplicações |

---

## Rede

### VPC — Virtual Private Cloud
- Rede privada isolada dentro da AWS
- **Subnet pública**: tem rota para Internet Gateway
- **Subnet privada**: sem acesso direto à internet
- **Security Group**: firewall stateful por instância (Allow only)
- **NACL**: firewall stateless por subnet (Allow e Deny)

### Conectividade
- **Direct Connect**: link físico dedicado do seu DC para a AWS (baixa latência, consistente)
- **VPN Site-to-Site**: túnel IPSec criptografado via internet pública
- **CloudFront**: distribui conteúdo via Edge Locations (CDN) — reduz latência global

---

## Monitoramento e Gerenciamento

| Serviço | Função |
|---|---|
| **CloudWatch** | Métricas, logs, alarmes e dashboards |
| **CloudTrail** | Log de auditoria de TODAS as chamadas de API |
| **AWS Config** | Histórico de configuração e verificação de conformidade |
| **Trusted Advisor** | Checa custo, segurança, fault tolerance, performance, limites de serviço |
| **Systems Manager** | Gerencia frota de EC2 (patch, run command, parâmetros) |

---

## Integração e Mensageria

| Serviço | Modelo | Uso |
|---|---|---|
| **SQS** | Fila (pull) | Desacoplar produtores e consumidores |
| **SNS** | Pub/sub (push) | Notificar múltiplos assinantes simultaneamente |
| **EventBridge** | Barramento de eventos | Conectar serviços AWS e apps via eventos |
| **Step Functions** | Workflow | Orquestrar funções Lambda e serviços em sequência |
