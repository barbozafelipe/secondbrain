---
tags: [aws, terraform, bedrock, textract, iam, s3, corpay-ai, servicenow, projeto-novo]
date: 2026-08-03
cluster/resource: "CORPAY-AI 176238383094 (ex-CONTAINER QA), us-east-1"
status: IaC criado localmente, pendente de confirmações antes do apply
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

**Rede:** sem VPC endpoint. Acesso via endpoints públicos da AWS, coerente com
o consumidor ser um SaaS externo.

## Achado relevante — bucket de teste já documentado

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

Detalhe completo em `docs/PENDENCIAS.md` do repo. Resumo:

1. **Nome do bucket** — aguardando confirmação final do Thiago.
2. **Model ID do Bedrock** — Thiago citou "Sonnet 3", que foi descontinuado
   pela Anthropic em jul/2025; precisa do model ID exato usado hoje, mais
   confirmar model access habilitado no console (não vem por Terraform).
3. **Bucket de state do Terraform** — precisa existir na conta CORPAY-AI antes
   do `init` (o bucket usado pelo `fleetcorbr-aws-repo-iac` é de outra conta,
   `867102406853`).
4. **Acesso de write na CORPAY-AI** — confirmar se o papel `BR_PS_CLOUD` no
   portal SSO permite criar IAM/S3, e se vai rodar local ou entrar numa
   pipeline.
5. **Entrega da access key** — gerada fora do Terraform (não fica no state),
   entregue via Connection & Credential Alias do ServiceNow, alinhado com a
   Larissa (aprovação) e o Thiago (uso).

## Próximos passos

1. Segunda-feira (2026-08-03 em diante): conversar com o Thiago pra fechar as
   pendências 1 e 2.
2. Decidir e aplicar bootstrap do bucket de state (pendência 3).
3. Confirmar acesso de write e rodar `terraform plan`/`apply`.
4. Gerar a access key e combinar entrega/rotação com Larissa + Thiago.
5. Depois de validado, subir o repo pro GitHub da empresa.

## Referências

- [[2026-07-02_iam-bedrockapikey-textract-s3-bucket-policy-bug]] — bucket
  sandbox, bug de policy IAM S3, comandos de diagnóstico úteis.
- [[demanda-ia-corpay-ai-bedrock]] — memória de sessão sobre a demanda (Claude Code).
- Repo IaC local: `C:\GitHub\corpay-ai-repo-iac`
