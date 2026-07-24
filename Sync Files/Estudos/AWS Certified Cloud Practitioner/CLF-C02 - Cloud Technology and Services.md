
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
- [x] EC2: tipos de instância, famílias (C, M, R, T), AMIs, estados
- [x] Lambda — serverless, event-driven, cobrança por invocação
- [x] ECS e EKS — orquestração de containers
- [x] Fargate — containers serverless (sem gerenciar nodes)
- [x] Elastic Beanstalk — PaaS para deploy de aplicações

**Armazenamento**
- [x] S3: classes (Standard, IA, Glacier), versionamento, lifecycle, políticas de bucket
- [x] EBS — block storage persistente para EC2
- [x] EFS — file system gerenciado e compartilhado (NFS)
- [x] S3 Glacier e Glacier Deep Archive — arquivamento de longo prazo
- [x] AWS Storage Gateway e AWS Backup

**Banco de dados**
- [x] RDS e Aurora — relacionais gerenciados (MySQL, PostgreSQL, Oracle...)
- [x] DynamoDB — NoSQL serverless, chave-valor, com Streams
- [x] Redshift — data warehouse para analytics
- [x] ElastiCache — cache em memória (Redis e Memcached)
- [x] DocumentDB (MongoDB-compatible) e Neptune (grafo)

**Rede e segurança de rede**
- [x] VPC: subnets públicas/privadas, route tables, Internet Gateway
- [x] Security Groups (stateful) vs NACLs (stateless)
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

### AWS Storage Gateway — lacuna de conteúdo (Q7 do simulado, ainda não revisado a fundo)
- Ponte híbrida: conecta seu ambiente **on-premises** ao armazenamento AWS, mantendo cache local para acesso rápido.
- 3 tipos de gateway — a prova testa qual usar em cada cenário:

| Tipo | O que faz | Palavra-chave na prova |
|---|---|---|
| **File Gateway** | Expõe buckets S3 como arquivos via NFS/SMB no seu servidor local | "acessar S3 como se fosse um file share local" |
| **Volume Gateway** | Apresenta volumes de disco iSCSI para servidores on-prem, com backup automático como snapshots no S3 | "backup de volumes on-premises para a nuvem" |
| **Tape Gateway** | Substitui a fita física — apresenta uma biblioteca de fitas virtual (VTL) compatível com softwares de backup existentes | "aposentar biblioteca de fitas físicas sem trocar o software de backup" |

> **Regra para a prova**: se o cenário menciona **"on-premises" + "sem migrar tudo de uma vez" + "cache local"**, é Storage Gateway. Se menciona especificamente "fita" (tape), é sempre **Tape Gateway**.

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

> [!danger] 🎯 Bloco de governança — lacuna confirmada (3 rodadas de erro seguidas: simulado 06/07, drill 08/07, drill 24/07)
> As 5 ferramentas abaixo aparecem juntas nas opções de questão porque todas "olham" a conta de algum jeito — mas cada uma responde a **um gatilho diferente**. A pergunta certa para diferenciar não é "o que ela monitora", é **"quando ela age"**.
>
> | Serviço | Gatilho — quando ela age | Frase-chave da prova |
> |---|---|---|
> | **AWS Config** | **Automático, em tempo real, todo desvio.** Dispara sozinho toda vez que um recurso monitorado muda de configuração e viola uma regra (ex: bucket virou público). Não é uma checagem periódica — é **notificação de desvio no momento em que acontece**. | "avisar automaticamente quando um recurso sair de conformidade", "histórico de mudanças de configuração", "regra de compliance contínua" |
> | **AWS Trusted Advisor** | **Sob demanda / periódico, visão geral da conta inteira.** Você (ou o painel) roda os checks e recebe recomendações gerais em 5 categorias (custo, segurança, tolerância a falhas, performance, limites de serviço). Não reage a um evento específico — é uma **auditoria geral da "saúde" da conta**. | "checar boas práticas da conta", "recomendações de custo/segurança de forma geral", "otimização não relacionada a um recurso específico" |
> | **AWS Service Catalog** | **Não monitora nada — controla o que pode ser criado.** É um catálogo de produtos/templates (ex: CloudFormation pré-aprovados) que o time de governança disponibiliza para que usuários provisionem só o que está autorizado, sem precisar saber Terraform/CloudFormation. | "autosserviço com governança", "padronizar o que usuários podem provisionar", "catálogo de produtos aprovados" |
> | **AWS Systems Manager (SSM)** | **Ação operacional sob comando, na frota.** Não é sobre compliance de conta — é sobre **executar** algo em instâncias EC2/on-prem: rodar patch, Run Command, gerenciar parâmetros/segredos (Parameter Store), sessão sem SSH. | "aplicar patch em várias instâncias", "rodar comando remoto sem SSH", "gerenciar parâmetros/segredos de app" |
> | **AWS CloudFormation** | **Não monitora nem audita — provisiona.** IaC nativa da AWS: você descreve a infra em um template (JSON/YAML) e ele cria/atualiza/destrói os recursos como uma *stack*. É a ferramenta que o Service Catalog empacota por trás. | "criar infraestrutura como código", "template que provisiona múltiplos recursos juntos", "stack" |
>
> **Teste rápido**: se a questão descreve algo acontecendo **sozinho e imediatamente** após uma mudança → Config. Se é uma **varredura geral, sem gatilho específico** → Trusted Advisor. Se é sobre **o que o usuário tem permissão de criar** → Service Catalog. Se é sobre **executar uma ação numa frota de instâncias** → Systems Manager. Se é sobre **criar a infraestrutura em si via template** → CloudFormation.

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

### Diferença SQS vs SNS vs EventBridge

| | SQS | SNS | EventBridge |
|---|---|---|---|
| **Modelo** | Fila (um consumidor por vez) | Pub/sub (vários assinantes) | Barramento de eventos |
| **Quando usar** | Desacoplar um produtor e um consumidor | Notificar múltiplos destinos ao mesmo tempo | Roteamento de eventos entre serviços AWS/SaaS |
| **Exemplo** | Pedido → fila → processamento | Alerta → e-mail + SMS + Lambda | CloudTrail event → trigger automação |

---

## Analytics e IA/ML

### Ferramentas de Analytics

| Serviço | O que faz | Quando usar |
|---|---|---|
| **Athena** | Executa queries SQL diretamente em arquivos no S3 (CSV, JSON, Parquet) sem provisionar servidores | Análise pontual de dados no S3 |
| **Glue** | ETL gerenciado: extrai dados de várias fontes, transforma e carrega no destino. Tem Data Catalog (catálogo de metadados) | Pipelines de dados e descoberta de esquema |
| **Redshift** | Data warehouse para analytics em petabytes de dados estruturados | Consultas complexas de BI sobre grandes volumes |
| **QuickSight** | Ferramenta de BI e visualização de dados (dashboards) | Criar gráficos e relatórios sobre dados AWS |
| **Kinesis Data Analytics** | Queries SQL em tempo real sobre streams Kinesis | Análise em tempo real (detecção de anomalias, métricas ao vivo) |

> **Regra para a prova**: Athena = query ad-hoc no S3. Glue = ETL e catálogo. Redshift = data warehouse. QuickSight = dashboards.

### Serviços de IA/ML

#### SageMaker
- Plataforma completa para criar, treinar e implantar modelos de Machine Learning
- Você traz seus próprios dados e algoritmos; a AWS gerencia a infraestrutura de treino e deploy
- Para a prova: é a resposta quando a questão pede um serviço para **treinar um modelo de ML customizado**

#### Serviços de IA pré-treinados (sem precisar saber ML)

| Serviço | O que faz | Exemplo de uso |
|---|---|---|
| **Rekognition** | Análise de imagens e vídeos (rostos, objetos, cenas, texto em imagem) | Moderar conteúdo, reconhecimento facial |
| **Polly** | Converte texto em fala (Text-to-Speech) | Narrar conteúdo, assistentes de voz |
| **Transcribe** | Converte fala em texto (Speech-to-Text) | Legendas automáticas, transcrição de reuniões |
| **Translate** | Tradução automática entre idiomas | Localizar conteúdo para múltiplos países |
| **Comprehend** | Processamento de linguagem natural (sentimento, entidades, idioma) | Analisar avaliações de clientes |
| **Lex** | Cria chatbots com voz e texto (mesmo motor do Alexa) | Assistente virtual, atendimento automatizado |
| **Kendra** | Busca inteligente em documentos usando ML | Motor de busca interno em bases de conhecimento |
| **Textract** | Extrai texto e dados de documentos (PDFs, imagens de formulários) | Digitalizar formulários, extrair dados de contratos |

> **Regra para a prova**: Se a questão descreve uma tarefa pronta (analisar imagem, traduzir, detectar sentimento), é um dos serviços de IA pré-treinados. Se pede para **criar e treinar** um modelo customizado, é **SageMaker**.

---

## Migração

### Estratégias de migração (revisando os 6 Rs)

Para migrar workloads on-premises para a AWS, a AWS define 6 estratégias:

| R | Nome | O que faz |
|---|---|---|
| **Rehost** | Lift-and-shift | Move a aplicação sem mudar nada. Rápido, sem benefício de cloud nativo |
| **Replatform** | Lift-and-reshape | Pequenas otimizações (ex: MySQL manual → RDS) sem mudar o código |
| **Repurchase** | Drop-and-shop | Substituir por SaaS (ex: CRM próprio → Salesforce) |
| **Refactor** | Re-architect | Reescrever para cloud-native (serverless, microsserviços). Mais caro, maior ganho |
| **Retire** | Descomissionar | Identificar e desligar o que não é mais necessário |
| **Retain** | Manter | Deixar on-premises por enquanto (compliance, dependência técnica) |

### Ferramentas de Migração

| Serviço | O que faz |
|---|---|
| **AWS Migration Hub** | Painel centralizado para acompanhar o progresso de todas as migrações |
| **Application Migration Service (MGN)** | Lift-and-shift automatizado de servidores físicos/VMs para EC2 |
| **Database Migration Service (DMS)** | Migra bancos de dados com downtime mínimo (suporta migrações homógeneas e heterogêneas) |
| **Schema Conversion Tool (SCT)** | Converte schema de um banco para outro tipo (ex: Oracle → PostgreSQL) |

### AWS Snow Family — Transferência Física de Dados

Usado quando transferir dados pela internet é inviável (muito volume, conexão lenta, sem conectividade):

| Dispositivo | Capacidade | Caso de uso |
|---|---|---|
| **Snowcone** | 8 TB | Edge computing em campo, transferência pequena, cabe na mochila |
| **Snowball Edge** | 80 TB | Transferência de grande volume, processamento local antes de enviar |
| **Snowmobile** | 100 PB | Migração de datacenters inteiros (chega em um caminhão) |

> **Regra para a prova**: Se a questão menciona "sem conexão de internet", "muitos TB/PB de dados", ou "migração física" → **Snow Family**.

---

## Developer Tools — CI/CD na AWS

A AWS tem um conjunto de serviços nativos para criar pipelines de integração e entrega contínua:

| Serviço | Função | Equivalente comum |
|---|---|---|
| **CodeCommit** | Repositório Git gerenciado na AWS | GitHub / GitLab |
| **CodeBuild** | Compila código, roda testes, gera artefatos | Jenkins / GitHub Actions |
| **CodeDeploy** | Faz o deploy do artefato em EC2, Lambda ou on-premises | Ansible / Octopus Deploy |
| **CodePipeline** | Orquestra todo o pipeline CI/CD (do commit ao deploy) | GitHub Actions / Azure DevOps |

### Fluxo típico

```
Código no CodeCommit
        ↓
   CodePipeline detecta o commit
        ↓
   CodeBuild compila e testa
        ↓
   CodeDeploy faz o deploy no EC2 / Lambda
```

> **Para a prova**: A questão vai descrever uma etapa do pipeline e perguntar qual serviço corresponde. Lembre: **Build** = CodeBuild, **Deploy** = CodeDeploy, **Orquestração** = CodePipeline, **Repositório** = CodeCommit.

---

## Outros Serviços Importantes

### AWS Outposts
- Hardware AWS instalado **fisicamente no seu datacenter** on-premises
- Permite rodar serviços AWS (EC2, RDS, EKS) localmente com baixa latência
- Para a prova: resposta para cenários que exigem cloud AWS mas com dados locais por compliance

### AWS Wavelength
- Extende a infraestrutura AWS para dentro das redes 5G das operadoras
- Para aplicações que precisam de latência ultra-baixa (jogos, IoT, AR/VR)

### AWS Global Accelerator
- Roteia tráfego pelo backbone privado da AWS (não pela internet pública)
- Reduz latência e melhora disponibilidade global
- **Diferente do CloudFront**: Global Accelerator é para qualquer protocolo TCP/UDP; CloudFront é CDN para conteúdo HTTP/S

### Amazon Connect
- Central de atendimento telefônico (call center) gerenciada na cloud

### AWS Trusted Advisor
- Analisa sua conta e dá recomendações em 5 categorias:
  1. **Cost Optimization** — recursos ociosos, reservas subutilizadas
  2. **Security** — MFA desabilitado, buckets públicos, portas abertas
  3. **Fault Tolerance** — AZ única, sem backup
  4. **Performance** — instâncias superprovisionadas
  5. **Service Limits** — uso próximo do limite da conta

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
