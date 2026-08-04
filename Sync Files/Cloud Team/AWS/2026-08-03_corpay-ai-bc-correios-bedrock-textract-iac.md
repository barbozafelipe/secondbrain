---
tags: [aws, terraform, bedrock, textract, iam, s3, corpay-ai, servicenow, projeto-novo, cloudtrail]
date: 2026-08-03
last_updated: 2026-08-03
cluster/resource: "CORPAY-AI 176238383094 (ex-CONTAINER QA) | Sandbox 003120962440 (referência real, investigada via CloudTrail)"
status: Thiago respondeu bloqueadores; faltam 2 confirmações pequenas + bootstrap do state antes do apply
---

# CORPAY-AI — provisionamento Bedrock/Textract/S3 pro projeto BC Correios

> [!info] Contexto
> Wellington pediu para renomear uma conta AWS ociosa (`CONTAINER QA`, ID
> `176238383094`) para **CORPAY-AI**, destinada a projetos de IA. A primeira
> demanda concreta chegou via chamado, pedindo estrutura pro projeto **BC
> Correios**: acesso a Bedrock e Textract, mais um bucket S3, consumidos pelo
> **ServiceNow Flow Designer**.

## Pessoas

- **Wellington Paradelas Feitosa** — pediu a renomeação da conta e o alinhamento inicial com o time da Larissa.
- **Larissa Balmant Cugliandro** — abriu o chamado (`RITM0910372`), time solicitante.
- **Thiago Henrique Biassi Da Silva** — contato técnico do lado do projeto BC Correios, quem de fato consome Bedrock/Textract via ServiceNow.

## Chamado

- Item de solicitação: `RITM0910372`
- Task (grupo Cloud/k8s): `TASK1260614`
- Descrição resumida: *"Aplicações (infra) - Configuração"* — configuração de contas e tokens para o projeto BC Correios em ambiente produtivo; liberar credenciais de acesso para uso do Textract e Bedrock.

## Arquitetura

```
[ServiceNow Flow Designer] (SaaS, fora da AWS)
        │  HTTPS/REST, autenticado via access key de IAM User
        ▼
[IAM User na conta CORPAY-AI] ──permissão──▶ [Bedrock: InvokeModel]
        │
        │ StartDocumentTextDetection (assíncrono)
        ▼
[Amazon Textract] ◀── lê o documento ── [Bucket S3]
        │
        │ polling: GetDocumentTextDetection
        ▼
[resultado volta pro ServiceNow]
        │
        │ DELETE do objeto (feito pela própria aplicação)
        ▼
[bucket fica limpo — lifecycle rule cobre o que a app não apagar]
```

**Por que IAM User (access key) e não IAM Role:** a aplicação roda no Flow
Designer do ServiceNow — SaaS, fora da AWS. Role só pode ser assumida por um
recurso de computação dentro da AWS (EC2/Lambda/EKS) via metadata/OIDC. Sem
esse mecanismo disponível, a credencial estática é o caminho correto — não é
falha de segurança, é a única opção real pra esse consumidor.

> [!warning] Atualização 2026-08-03 — não é UMA credencial, são DUAS
> A investigação do sandbox (seção abaixo) mostrou que o Bedrock usa um
> mecanismo de auth diferente (bearer token) do S3/Textract (access key SigV4).
> Ver "Achado 3" abaixo.

**Rede:** sem VPC endpoint. Acesso via endpoints públicos da AWS, coerente com
o consumidor ser um SaaS externo.

## Achado 1 — bucket de teste já documentado

O bucket de teste que o Thiago criou (`snow-s3-textract-bucket`) **não está na
conta CORPAY-AI** — vive na conta **Sandbox** (`003120962440`, `us-east-1`),
já documentado em
[[2026-07-02_iam-bedrockapikey-textract-s3-bucket-policy-bug|policy inline do BedrockAPIKey-zwcz nesse mesmo bucket]].
Como nome de bucket S3 é único globalmente (não por conta), esse nome não pode
ser reaproveitado na CORPAY-AI sem excluir o da sandbox primeiro — decisão foi
usar um nome novo (`corpay-ai-snow-s3-textract-bucket`) em vez de mexer no
recurso da sandbox.

Essa nota antiga também documenta um bug real de policy (ARN de bucket vs.
`bucket/*` para ações de objeto) que serve de checklist pra não repetir na
policy nova.

## Investigação do sandbox (2026-08-03) — comparar com a arquitetura real

O usuário sugeriu acessar a conta sandbox pra ver como a arquitetura já funciona
lá antes de fechar o Terraform. Login via `aws sso login --profile
BR_PS_CLOUD-003120962440`, inspeção de bucket + IAM + **CloudTrail** (90 dias de
eventos `InvokeModel`). Achados relevantes:

### Achado 2 — a "avaliação de custo" do Thiago já é fato consumado

CloudTrail mostra dois usuários IAM distintos ao longo do tempo:

| Período | Usuário IAM | Model ID invocado | Forma |
|---|---|---|---|
| até 2026-07-21 | `BedrockAPIKey-zwcz` | `anthropic.claude-3-sonnet-20240229-v1:0` | direto |
| a partir de 2026-07-30 | `BedrockAPIKey-51ot` | `global.anthropic.claude-sonnet-4-6` | via inference profile **global** |

O "Sonnet 3" que o Thiago citou era de fato o Claude 3 Sonnet (descontinuado pela
Anthropic em jul/2025) — e a migração pro Sonnet 4.6 **já aconteceu**, não é mais
avaliação. `bedrock_foundation_models`/`bedrock_inference_profiles` no Terraform
já atualizados com esses valores reais.

**Efeito colateral na policy:** o profile `global.*` roteou inferência pra
`ap-northeast-1`, `ap-southeast-4`, `eu-west-1` e `eu-west-2` — tudo numa janela
de minutos. `main.tf` foi ajustado pra usar wildcard de região no ARN do
foundation model (padrão recomendado da AWS pra cross-region/global inference
profile) em vez de listar regiões específicas, que quebraria a cada rota nova.

### Achado 3 — Bedrock usa "Bedrock API key" (bearer token), não access key SigV4

`"callWithBearerToken": true` em 100% das chamadas de `InvokeModel` no
CloudTrail. Isso é um **IAM Service Specific Credential** pro serviço
`bedrock.amazonaws.com` (`aws iam create-service-specific-credential`), não a
access key clássica — provavelmente porque o Flow Designer não implementa
assinatura SigV4 completa e usa o método bearer token mais simples que a AWS
oferece especificamente pro Bedrock.

**Esse token expira** (confirmado: 30 dias pro `zwcz`, 90 dias pro `51ot`) — e
já causou um incidente real no sandbox: quando o token do `zwcz` expirou em
2026-07-24, em vez de rotacionar, criaram um usuário inteiro novo (`51ot`). Sem
plano de rotação isso se repete em produção, com o BC Correios parando de
verdade.

S3 e Textract continuam precisando da access key clássica — o bearer token é
específico do Bedrock.

### Achado 4 — divergência de região (dito ≠ real, de novo)

O Thiago corrigiu no Teams: *"a região é us-east-1"*. Mas **100% dos eventos**
de `InvokeModel` no CloudTrail batem em `bedrock-runtime.sa-east-1.amazonaws.com`
— não é o `inferenceRegion` (que varia, é do profile global), é a região do
**endpoint** que o Flow Designer chama. Mesmo padrão do achado do Imperva no
projeto Gringo: o que foi dito diverge do que está configurado de fato.
`terraform.tfvars` mantém `us-east-1` (última palavra do Thiago) mas com
pendência aberta — **não aplicar até resolver isso**, trocar região depois do
apply implica recriar bucket e toda a policy.

### Achado 5 — Textract nunca foi chamado de verdade no sandbox

Zero eventos de `StartDocumentTextDetection` nos últimos 90 dias de CloudTrail.
O fluxo assíncrono que o Thiago descreveu (`Start` + polling `Get`) parece ser
o desenho pretendido, mas só o Bedrock foi de fato exercitado até agora. Vale
perguntar se o Textract já foi validado em outro lugar.

### Achado 6 — config do bucket sandbox, pra comparação

SSE-S3/AES256 com bucket key, `BucketOwnerEnforced`, public access block total,
**sem** bucket policy (controle só via IAM), **sem** versionamento, **sem**
lifecycle rule, **sem** tags. Nossa stack replica o essencial e vai além em dois
pontos — lifecycle de expiração (rede de segurança pro DELETE que a app faz) e
bucket policy deny-non-TLS — que não existem no sandbox. Não é algo a reverter,
é melhoria mesmo.

## Respostas do Thiago (2026-08-03)

Mandei as 4 perguntas bloqueantes + 3 informativas dos achados acima. Respostas:

| # | Pergunta | Resposta | Efeito |
|---|---|---|---|
| Região | `us-east-1`? | Confirmado — *"Isso, na região us-east-1"* | **Resolvido.** Sandbox usa `sa-east-1`, mas são contas diferentes; sem conflito real, era só coincidência de contas distintas. |
| Nome do bucket | — | `sn_bucket_textract` | Nome **inválido** (S3 não aceita underscore) — convertido pra `sn-bucket-textract`, checado como disponível. Falta ele confirmar a troca. |
| Modelo Bedrock | Sonnet 4.6 é definitivo? | *"Ainda estamos vendo se vamos usar o Sonnet 3 ou 4.6"* — decisão de custo é da Larissa | Terraform ajustado pra liberar **os dois modelos** de uma vez, não trava esperando decisão de negócio. |
| Auth do Bedrock | Bearer token ou SigV4? | *"O token é mais fácil aqui pra mim"* | **Resolvido** — segue Bedrock API key (bearer token), igual ao sandbox. Falta só definir quem rotaciona antes de expirar. |
| Volume | docs/dia | "50, 70, 100, 150, difícil ter média" | Sem risco de quota do Textract nesse volume — resolvido, sem ação. |
| KMS/CMK | — | "Não entendi" | Pergunta mal formulada da minha parte — vou reformular mais simples numa próxima rodada. |
| Textract validado? | — | Ainda validando com a área + custo do Sonnet 4.6 com a Larissa | Não bloqueia o Terraform (policy já cobre), só confirma que o fluxo real ainda não rodou ponta a ponta. |

**O que ainda falta pro Terraform ficar 100% pronto** (`docs/PENDENCIAS.md` tem o
detalhe): confirmação da troca underscore→hífen no bucket, definir quem rotaciona
o Bedrock API key, e as três pendências internas nossas (bucket de state,
acesso de write, canal de entrega de credencial com a Larissa).

## IaC criado

Repositório local (ainda não subiu pro GitHub da empresa):
`C:\GitHub\corpay-ai-repo-iac`

```
corpay-ai-repo-iac/
├── README.md
├── docs/PENDENCIAS.md          checklist do que falta confirmar
└── BC-CORREIOS/PRD/
    ├── backend.tf              comentado — falta bucket de state na conta
    ├── versions.tf
    ├── providers.tf            allowed_account_ids trava a conta CORPAY-AI
    ├── variables.tf
    ├── main.tf                 S3 (SSE-S3, public access block, deny non-TLS,
    │                           lifecycle de expiração) + IAM User + policy mínima
    ├── outputs.tf
    └── terraform.tfvars
```

`terraform fmt` e `terraform validate` passaram (Terraform 1.14.4, provider
AWS 6.57.1). Não rodou `plan`/`apply` — falta credencial e as pendências
abaixo.

A policy do IAM User cobre exatamente as duas chamadas do Textract em uso
(`StartDocumentTextDetection` assíncrono + `GetDocumentTextDetection` polling)
e `bedrock:InvokeModel`/`InvokeModelWithResponseStream` restrito aos ARNs dos
modelos configurados — nada de managed policy larga tipo
`AmazonTextractFullAccess` (que foi o que o `BedrockAPIKey-zwcz` da sandbox
usava, ver nota linkada acima).

## Pendências antes do apply

Detalhe completo e atualizado em `docs/PENDENCIAS.md` do repo. Resumo pós-respostas
do Thiago (2026-08-03):

1. ~~Nome do bucket~~ — quase resolvido: Thiago deu `sn_bucket_textract`, convertido
   pra `sn-bucket-textract` (underscore inválido em nome de S3). Falta confirmar a troca.
2. ~~Model ID do Bedrock~~ — resolvido pro Terraform: libera os dois modelos
   candidatos (Sonnet 3 e 4.6) já que a decisão de negócio (Larissa, custo) ainda
   não fechou. Falta habilitar model access no console da CORPAY-AI pros dois.
3. ~~Mecanismo de auth do Bedrock~~ — **resolvido**: bearer token (Bedrock API
   key), confirmado pelo Thiago. Falta só definir quem rotaciona antes de expirar.
4. ~~Região~~ — **resolvido**: `us-east-1` confirmado. Era coincidência de contas
   diferentes (sandbox em `sa-east-1`), não divergência real.
5. **Bucket de state do Terraform** — ainda pendente, decisão nossa (não do
   Thiago). Precisa existir na conta CORPAY-AI antes do `init`.
6. **Acesso de write na CORPAY-AI** — ainda pendente, decisão nossa.
7. **Entrega das credenciais** (duas: access key + Bedrock API key) — falta
   combinar canal com a Larissa e definir rotação.

## Próximos passos

1. Confirmar com o Thiago a troca underscore→hífen no bucket (rápido).
2. Definir quem rotaciona o Bedrock API key antes de expirar.
3. Decidir e aplicar bootstrap do bucket de state.
4. Confirmar acesso de write e rodar `terraform plan`/`apply`.
5. Gerar as duas credenciais e combinar entrega/rotação com Larissa + Thiago.
6. Depois de validado, subir o repo pro GitHub da empresa.

## Referências

- [[2026-07-02_iam-bedrockapikey-textract-s3-bucket-policy-bug]] — bucket
  sandbox, bug de policy IAM S3, comandos de diagnóstico úteis.
- [[demanda-ia-corpay-ai-bedrock]] — memória de sessão sobre a demanda (Claude Code).
- Repo IaC local: `C:\GitHub\corpay-ai-repo-iac`
