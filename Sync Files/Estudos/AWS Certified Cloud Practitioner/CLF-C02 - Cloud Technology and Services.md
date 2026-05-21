
# CLF-C02 - Cloud Technology and Services

**Domínio 3 · 34% da prova** | Parte de: [[AWS Certified Cloud Practitioner]]

---

## 🔔 Lembrete 2 — Revisar Cloud Technology & Services

**Data:** 21/05/2026 (Qui) · 16h | ⏱️ Tempo estimado: 60 min *(domínio mais pesado)*

> [!info] Primeiro passo (2 min)
> Vá direto para a seção **Armazenamento → S3** e **Mensageria → Kinesis**. Você já usou ambos em tarefas reais (TASK1231707 e CTASK0133209). Marcar o que já sabe libera energia para o que ainda precisa aprender.

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
- [ ] S3: classes (Standard, IA, Glacier), versionamento, lifecycle, políticas de bucket
- [ ] EBS — block storage persistente para EC2
- [ ] EFS — file system gerenciado e compartilhado (NFS)
- [ ] S3 Glacier e Glacier Deep Archive — arquivamento de longo prazo
- [ ] AWS Storage Gateway e AWS Backup

**Banco de dados**
- [ ] RDS e Aurora — relacionais gerenciados (MySQL, PostgreSQL, Oracle...)
- [ ] DynamoDB — NoSQL serverless, chave-valor, com Streams
- [ ] Redshift — data warehouse para analytics
- [ ] ElastiCache — cache em memória (Redis e Memcached)
- [ ] DocumentDB (MongoDB-compatible) e Neptune (grafo)

**Rede e segurança de rede**
- [ ] VPC: subnets públicas/privadas, route tables, Internet Gateway
- [ ] Security Groups (stateful) vs NACLs (stateless)
- [ ] Route 53 — DNS gerenciado, roteamento de tráfego
- [ ] CloudFront — CDN global com Edge Locations
- [ ] Direct Connect — conexão dedicada on-premises ↔ AWS
- [ ] VPN Site-to-Site — túnel criptografado via internet
- [ ] Elastic Load Balancing: ALB (camada 7), NLB (camada 4)

**Certificados e segurança de aplicação**
- [ ] ACM (AWS Certificate Manager) — emissão e importação de certificados TLS
- [ ] KMS — gerenciamento de chaves de criptografia
- [ ] Secrets Manager — rotação automática de credenciais

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
- [ ] Kinesis Data Streams — ingestão de dados em tempo real
- [ ] Kinesis Data Firehose — entrega gerenciada de streams para S3, Redshift etc.

**Analytics e IA/ML**
- [ ] Athena — queries SQL diretamente no S3 (serverless)
- [ ] Glue — ETL gerenciado e catálogo de dados
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

> [!tip] 🔗 Conexão com o trabalho
> Na CTASK0133209 (Kinesis + DynamoDB para APP-Vehicles), você viu que uma Lambda foi utilizada como ponte entre o DynamoDB Stream e o Kinesis Data Stream. O padrão event-driven (DynamoDB emite evento → Lambda processa → Kinesis recebe) é exatamente o que a prova testa como caso de uso de Lambda.

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

### Bucket Policies — Acesso entre contas (Cross-account)
- Uma **Bucket Policy** é um JSON atachado diretamente ao bucket S3 que define quem pode fazer o quê nele
- Para liberar acesso entre contas AWS, a policy usa o ARN da conta de origem no campo `Principal`

> [!tip] 🔗 Conexão com o trabalho
> Na TASK1231707 (cpay-vehmkmod-dev/qa/prd) e na nota "Permitir visibilidade de S3 em outra conta", você aplicou exatamente esse padrão: criar uma Bucket Policy que autoriza outra conta (`284309077449` — a DLA) a ler e escrever nos buckets S3 nas contas STP DEV, QA e PRD. Isso é acesso cross-account via Bucket Policy — tópico direto da prova.
>
> Regra para a prova: **Bucket Policy** controla acesso ao bucket. **IAM Policy** controla o que o usuário/role pode fazer. Para cross-account, você precisa dos **dois lados**: a Bucket Policy permitir a conta de origem + a IAM Policy da conta de origem permitir ações em S3.

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

### DynamoDB Streams
- Captura modificações (insert, update, delete) em tabelas DynamoDB em tempo real
- Pode ser consumido por Lambda para processar eventos automaticamente

> [!tip] 🔗 Conexão com o trabalho
> Na CTASK0133209, você habilitou o **DynamoDB Stream** na tabela APP-Vehicles com "New and old images" para capturar as mudanças e enviar para o Kinesis. Isso é o padrão clássico de streaming de dados — e é exatamente o que o exame pergunta quando menciona "como capturar mudanças em tempo real no DynamoDB?". Resposta: DynamoDB Streams.

---

## Rede

### VPC — Virtual Private Cloud
- Rede privada isolada dentro da AWS
- **Subnet pública**: tem rota para Internet Gateway
- **Subnet privada**: sem acesso direto à internet
- **Security Group**: firewall stateful por instância (Allow only)
- **NACL**: firewall stateless por subnet (Allow e Deny)

### Elastic Load Balancing (ELB)
| Tipo | Camada | Caso de uso |
|---|---|---|
| **ALB** | 7 (HTTP/HTTPS) | Roteamento por path, host, headers |
| **NLB** | 4 (TCP/UDP) | Alta performance, baixa latência |
| **CLB** | 4 e 7 | Legado — evitar em novos projetos |

> [!tip] 🔗 Conexão com o trabalho
> Na nota "Certificado no LoadBalancer" e nas tasks de certificados (CTASK0133893, CTASK0134619), você atualizou certificados TLS que ficam atachados nos **ALBs (Application Load Balancers)**. O ALB opera na camada 7 e é o tipo de Load Balancer que entende HTTPS — por isso é nele que os certificados do ACM são associados.

### Conectividade
- **Direct Connect**: link físico dedicado do seu DC para a AWS (baixa latência, consistente)
- **VPN Site-to-Site**: túnel IPSec criptografado via internet pública
- **CloudFront**: distribui conteúdo via Edge Locations (CDN) — reduz latência global

---

## Certificados e Segurança de Aplicação

### ACM — AWS Certificate Manager
- Emite certificados TLS gratuitos (domínios validados via DNS ou e-mail)
- Permite **importar certificados externos** (de CAs como DigiCert, Sectigo etc.)
- Integra nativamente com ALB, CloudFront, API Gateway
- **Certificado SAN (Subject Alternative Names)**: um único certificado que cobre múltiplos domínios

> [!tip] 🔗 Conexão com o trabalho
> Você é especialista nisso na prática. Nas tasks CTASK0133893 e CTASK0134619, você importou certificados DigiCert no ACM seguindo o padrão:
> - **Certificate body** → arquivo do certificado do domínio
> - **Certificate chain** → DigiCertCA (intermediário)
> - **Private key** → arquivo pkcs8
>
> E descobriu um comportamento importante do **certificado SAN multi-account**: atualizar em uma conta pode fazer o Imperva reconhecer para todas — porque o Imperva valida pelo fingerprint, não pela conta AWS. Isso é conhecimento avançado que vai além da prova, mas fixa o conceito de SAN de forma permanente.

### KMS — Key Management Service
- Gerencia chaves de criptografia usadas por outros serviços AWS (S3, EBS, RDS, Kinesis etc.)
- Criptografia server-side: SSE-KMS usa chaves do KMS para criptografar dados em repouso

> [!tip] 🔗 Conexão com o trabalho
> Na CTASK0133209, ao criar o Kinesis Data Stream, você habilitou a opção **Encryption: KMS default** — isso é o KMS gerenciando a chave que criptografa os dados em trânsito dentro do stream. Toda vez que você habilitou criptografia em algum serviço AWS, o KMS estava envolvido por baixo.

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

### Kinesis — Streaming de Dados em Tempo Real

| Serviço | O que faz |
|---|---|
| **Kinesis Data Streams** | Ingere e armazena dados em tempo real para consumo por aplicações |
| **Kinesis Data Firehose** | Entrega gerenciada de streams para destinos (S3, Redshift, OpenSearch) |
| **Kinesis Data Analytics** | Queries SQL em tempo real sobre streams |

> [!tip] 🔗 Conexão com o trabalho
> A CTASK0133209 foi um exercício completo de arquitetura de dados em tempo real com Kinesis:
> - Você criou um **Kinesis Data Stream** (app-vehicles-stream) para receber os eventos do DynamoDB em tempo real
> - Depois configurou um **Kinesis Data Firehose** (DNA_Vehicles) que lê desse stream e entrega os arquivos no bucket S3 da DLA (flt-dna-l0-landing)
> - O Firehose ainda passou por uma Lambda de transformação antes de chegar no S3
>
> Esse é o padrão de arquitetura: **DynamoDB Streams → Lambda → Kinesis Data Streams → Firehose → S3**. Para a prova: Data Streams é para ingestão/consumo em tempo real; Firehose é para entrega gerenciada a um destino.
>
> Você também aprendeu que quando o destino S3 está em **outra conta**, não é possível selecionar pelo console — é necessário usar CLI (`aws firehose update-destination`). Isso é conhecimento além da prova, mas reforça o entendimento de cross-account.
