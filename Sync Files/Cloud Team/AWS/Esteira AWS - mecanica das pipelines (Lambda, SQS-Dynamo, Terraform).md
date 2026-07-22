---
tags: [aws, esteira, github-actions, terraform, lambda, sqs, dynamodb, devops, runbook]
status: ativo
---

# Esteira AWS — mecânica real das pipelines (Lambda, SQS/DynamoDB, Terraform)

> [!info] Origem
> Descoberto em 22/07/2026 ao explorar o repositório `SemParar-Alm/devops_documentation` (acesso via GitHub corporativo). Resolve a dúvida recorrente de "como a esteira funciona na prática" que apareceu no projeto Chatbot Gringo — ver [[2026-07-02_chatbot-gringo-zendesk-agentcore]].

## Terraform AWS (`pipeline-aws-iac-v2.yml`)

- **Template**: `SemParar-Alm/templates-pipelines-actions/.github/workflows/pipeline-aws-iac-v2.yml@master`. Repo consumidor só precisa de `.github/workflows/main.yml` chamando esse workflow.
- **Gatilhos**: PR/push pra `master`/`develop` quando `.tf`/`.tfvars`/`.hcl` mudam, ou `workflow_dispatch` manual.
- **Descoberta automática de pastas alteradas**: só considera diretórios que são **root modules** (têm `.tf` no primeiro nível). Detecta pasta removida → gera plano de `destroy` automaticamente.
- **Ambiente resolvido pelo path**: `FINTECH/PRD/vpc` → `fintech-prd`, `TRIADE-QA/vpc` → `triade-qa`, `INFRA/DEV/network` → `infra-dev`. Tokens reconhecidos: dev/develop/development→dev, qa→qa, hml/homolog→hml, stg/stage/staging→stg, prd/prod/production→prd.
- **Auth via OIDC** — variável `AWS_ROLE_TO_ASSUME` no GitHub Environment (sem credencial estática). Suporta role chaining com `AWS_TARGET_ROLE_TO_ASSUME`.
- **`apply` só roda manual** (`workflow_dispatch`), nunca automático em push/PR — PR/push só fazem `plan`.
- Bloqueia execução se detectar `terraform.tfstate` versionado no repo.
- **Repositório de referência real**: `SemParar-Alm/fleetcorbr-aws-repo-iac` — organizado por "frente" de negócio na raiz: `FINTECH/`, `FREEFLOW/`, `INFRA/`, `PARCERIAS/`, `STP/`, `TRIADE/`, mais `MODULES/` compartilhado. **⚠️ Não tem pasta Zapay/Gringo** — essa pipeline hoje parece cobrir só contas do lado Corpay/SemParar clássico, não a org Zapay. Confirmar com DevOps se dá pra estender pra contas Zapay (tecnicamente é só configurar outra role AWS via OIDC) ou se existe pipeline equivalente separada pro lado Zapay.

## Lambda (`pipeline-lambda.yml`)

- **Template**: `SemParar-Alm/templates-pipelines-actions/.github/workflows/pipeline-lambda.yml@master`.
- **Nomenclatura do repo**: precisa começar com `NJS` (JS) ou `NTS` (TS) + nome da frente/squad. Ex: `NJS-APP-Login`, `NTS-Common-DigitalParking`.
- **Arquivo `deploy.json`** por função, com `FunctionName`, `Projeto`, `UsaVPC` (Sim/Não), `Release`, `Configuration` (Runtime, Handler, Timeout, MemorySize, Environment Variables), `ReservedConcurrentExecutions`, `Tags`, e opcionalmente `SQS_Trigger` (EventSourceArn, Enabled, BatchSize).
- **⚠️ Confirma a limitação documentada no incidente Carvalt/Afinz** (ver [[30-06-2026]]): `UsaVPC` é só um booleano — não dá pra escolher subnet/SG específico, só "usa VPC padrão ou não".
- **Arquivo `lambda-profile-env`**: lista a(s) "conta(s)" de destino — na verdade um **código de frente** (`FINTECH`, `STP`), não um Account ID AWS direto. Frente → conta é mapeado internamente pelo time de Arquitetura/DevOps.
- **Ambiente pela branch**: `develop` → DEV; `release` → QA (e PRD se "Versionar" marcado, cria tag + publica pacote).
- **⚠️ Documentação encontrada é só pra Node.js** (`nodejs20.x`, `npm install`, etc.) — não há doc de Lambda Python nesse repositório. As Lambdas do Chatbot Gringo são Python — perguntar ao DevOps se a mesma pipeline suporta Python (parâmetro `Runtime` no `deploy.json` parece genérico, só documentado com exemplo Node) ou se há doc/pipeline separada não encontrada ainda.
- Erros comuns documentados: `AccessDenied`/`AccessDeniedException` (falta permissão IAM na role, resolver com time de Cloud), `InvalidParameterValueException: provided execution role does not exist` (também pode ocorrer quando SG/Subnet tem número excessivo de IDs).

## SQS & DynamoDB (`pipeline-awsproducts.yml`)

- **Template**: `SemParar-Alm/templates-pipelines-actions/.github/workflows/pipeline-awsproducts.yml@master`. Roda no **mesmo repositório das APIs** (workflow identificado como "AWS-Products").
- **Estrutura de pastas**: `Dynamo/` e/ou `Sqs/` na raiz → subpasta por "conta"/frente (ex: `CPP`) → arquivo `generate.formation.js` (gera os outputs) + arquivos de definição de cada tabela/fila.
- **Arquivo `dynamo-profile-env`/`sqs-profile-env`**: lista as contas/frentes de destino, maiúsculas.
- **Ambiente pela branch**: mesmo padrão do Lambda (develop=DEV, release=QA/PRD).
- Recomendação: executar um produto por vez se o repo tiver mais de um (Dynamo e SQS juntos podem gerar conflito de workflow).

## Criação de novos projetos/repositórios (`create-project.yml`)

Sistema que automatiza: criação de repo GitHub → permissões/branch protection → SonarQube → namespaces OpenShift (dev/qa/pprd) → produção → ArgoCD sync. Padrões de nomenclatura por tecnologia: Lambda `NJS*`/`NTS*`, Java `ms*`, Angular `ang*`/`rjs*`, Python `py*`, Node `nst*`/`nod*`, Golang `go*`. Ambientes QA sem reviewers obrigatórios; PRD/PPRD/FALLBACK com reviewers do time OPERACOES.

## Ver também

- [[2026-07-02_chatbot-gringo-zendesk-agentcore]] — projeto que motivou essa investigação
- Repo fonte: `SemParar-Alm/devops_documentation` (privado, GitHub corporativo)
- Repo de templates: `SemParar-Alm/templates-pipelines-actions`
- Repo de referência Terraform AWS: `SemParar-Alm/fleetcorbr-aws-repo-iac`
