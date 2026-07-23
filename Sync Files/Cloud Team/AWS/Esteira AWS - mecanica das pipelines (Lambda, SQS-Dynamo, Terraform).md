---
tags: [aws, esteira, github-actions, terraform, lambda, sqs, dynamodb, devops, runbook, referencia]
status: ativo
last_updated: 2026-07-22
---

# Esteira AWS — mecânica real das pipelines (Lambda, SQS/DynamoDB, Terraform, S3, API)

> [!info] Origem e método
> Levantado em 22/07/2026 a partir de **duas fontes**: (1) o repositório de documentação `SemParar-Alm/devops_documentation`, e (2) **leitura direta do código** dos templates (`templates-pipelines-actions`, pasta `aws/` enviada ao time do Chatbot Gringo).
> **Onde as duas divergem, o código vence** — e diverge em pontos importantes (ver seções de "achados"). Motivado pelo projeto [[2026-07-02_chatbot-gringo-zendesk-agentcore]], mas escrito para servir a qualquer demanda futura.

---

## 1. O modelo mental: três peças, não uma

Esta é a parte que mais gera confusão em quem chega. A esteira **não é um lugar onde você vai** — é uma biblioteca que o seu repositório chama.

| # | Peça | O que é | Você mexe? |
|---|---|---|---|
| 1 | `templates-pipelines-actions` | A **biblioteca**: contém os `pipeline-*.yml` e todas as composite actions (build, test, deploy, rollback, sonar) + os scripts `.sh` que fazem as chamadas AWS de verdade | ❌ Nunca. Só referencia |
| 2 | **Repositório do projeto** | Código da aplicação + arquivos de config + um `main.yml` pequeno que chama a biblioteca. **É daqui que a pipeline roda** | ✅ Sim, é o seu |
| 3 | GitHub Environments + contas AWS | Credenciais/roles por ambiente. A pipeline resolve qual usar pela branch ou pelo path da pasta | ⚠️ Configurado pelo DevOps |

**Fluxo:** `repo do projeto (main.yml)` → `uses:` → `pipeline-*.yml` no repo de templates → composite actions → scripts `.sh` → AWS CLI → conta AWS.

### Por que os templates não rodam sozinhos

Todo `pipeline-*.yml` começa com:

```yaml
on:
  workflow_dispatch:
  workflow_call:      # ← reusable workflow: só pode ser CHAMADO de fora
```

`workflow_call` é a marcação de *reusable workflow* do GitHub Actions. Arquivo com isso existe para ser referenciado remotamente, **nunca para ser copiado para dentro de um projeto**.

> [!warning] Sintoma comum de mal-entendido
> Se alguém receber a pasta de templates e tentar rodar/copiar, vai quebrar — e não é erro de configuração. Além do `workflow_call`, as composite actions referenciam scripts em `templates-pipelines-actions/.github/workflows/scripts/aws/**/*.sh` que normalmente **não vêm junto** quando alguém compartilha só a pasta `aws/`. O trabalho real contra a AWS mora nesses scripts.

### O `main.yml` que o projeto precisa ter

```yaml
# .github/workflows/main.yml — no repositório DO PROJETO
name: Deploy Lambda
on:
  workflow_dispatch:
    inputs:
      operacao:  { type: string,  required: true }
      arquivo:   { type: string,  required: true }
      release:   { type: string,  required: true }
      versionar: { type: boolean, default: false }

jobs:
  lambda:
    uses: SemParar-Alm/templates-pipelines-actions/.github/workflows/pipeline-lambda.yml@master
    with:
      operacao:  ${{ inputs.operacao }}
      arquivo:   ${{ inputs.arquivo }}
      release:   ${{ inputs.release }}
      versionar: ${{ inputs.versionar }}
    secrets: inherit
```

É literalmente isso. Todo o resto (dependências, Sonar, empacotamento, deploy, rollback) já está do outro lado.

---

## 2. Como cada esteira resolve o ambiente

Diferença fundamental entre as famílias de pipeline — fonte recorrente de confusão:

| Família | Resolve ambiente por | Exemplo |
|---|---|---|
| Lambda, SQS, DynamoDB, CloudFormation | **Branch** | `develop`→DEV · `release`→QA · `release` + flag `versionar`→PRD |
| Terraform AWS | **Path da pasta** | `FINTECH/PRD/vpc` → environment `fintech-prd` |

**Conta AWS de destino** (Lambda/SQS/Dynamo): não é Account ID. Vem de um arquivo de profile (`lambda-profile-env`, `sqs-profile-env`, `dynamo-profile-env`) contendo o **código da frente** em maiúsculas — `FINTECH`, `STP`, `CPP`. O mapeamento frente→conta é interno do time de Arquitetura/DevOps.

---

## 3. Catálogo de pipelines

| Pipeline | Template | Para quê |
|---|---|---|
| `pipeline-lambda.yml` | Lambda | Deploy de funções Lambda (**Node.js apenas** — ver §5) |
| `pipeline-awsproducts.yml` | SQS + DynamoDB | Criação/atualização de filas e tabelas via CloudFormation |
| `pipeline-cloudformation.yml` | API Gateway | Deploy de APIs via CloudFormation |
| `pipeline-s3.yml` | S3 | **Publicação de conteúdo estático** (não cria bucket — ver §6) |
| `pipeline-aws-iac-v2.yml` | Terraform | IaC genérico multi-recurso |

---

## 4. Terraform AWS (`pipeline-aws-iac-v2.yml`)

A esteira mais flexível e a mais parecida com trabalho de infra "normal".

- **Gatilhos**: PR/push em `master`/`develop` quando muda `.tf`/`.tfvars`/`.hcl`, ou `workflow_dispatch`.
- **Descoberta automática**: calcula o diff e roda só nas pastas alteradas que sejam **root modules** (têm `.tf` no primeiro nível). Se uma pasta de root module foi **removida**, gera plano de `destroy` automaticamente.
- **`plan` em PR/push; `apply` só em `workflow_dispatch` manual.** Nunca aplica sozinho.
- **Auth via OIDC**: variável `AWS_ROLE_TO_ASSUME` no GitHub Environment (sem credencial estática). Suporta role chaining com `AWS_TARGET_ROLE_TO_ASSUME`.
- **Trava de segurança**: bloqueia execução se detectar `terraform.tfstate` versionado no repo.
- **Tokens de ambiente reconhecidos no path**: `dev|develop|development`→dev · `qa`→qa · `hml|homolog|homologation`→hml · `stg|stage|staging`→stg · `prd|prod|production`→prd.
- **Repo de referência**: `SemParar-Alm/fleetcorbr-aws-repo-iac` — organizado por frente na raiz (`FINTECH/`, `FREEFLOW/`, `INFRA/`, `PARCERIAS/`, `STP/`, `TRIADE/`) + `MODULES/` compartilhado.

> [!warning] Gap conhecido: cobertura de contas
> O repo de referência **não tem pasta Zapay/Gringo** — a pipeline hoje cobre as frentes clássicas Corpay/SemParar. Tecnicamente estender é só configurar outra role via OIDC no GitHub Environment, mas precisa ser validado com o DevOps antes de assumir que funciona.

---

## 5. Lambda (`pipeline-lambda.yml`)

### Jobs da pipeline (ordem real)

| Job | O que faz | Quando |
|---|---|---|
| `prepare-pipeline` | Valida arquivos/parâmetros, define variáveis, **checa `console.log`/`console.info` proibidos**, instala dependências | sempre |
| `test` | Testes unitários + SonarQube com **Quality Gate bloqueante** | sempre |
| `build` | Empacota a função, valida os JSONs gerados, sobe artefato | sempre |
| `deploy` | Deploy em ambiente não-produtivo + cria tag no repo | sempre |
| `prepare-rollback` | Guarda a versão anterior para permitir voltar atrás | release/hotfix + `versionar` |
| `deploy-prd` | **Change Validation (ServiceNow)** → deploy em produção | release/hotfix + `versionar` |
| `deploy-rollback` | Rollback automático se o deploy de PRD falhar | automático em falha |

**Valor real de entrar na esteira:** rollback automático, Change Validation e Quality Gate vêm de graça — coisas que normalmente não existem em deploy manual.

### Requisitos do repositório

- **Nome do repo** precisa começar com `NJS` (JavaScript) ou `NTS` (TypeScript) + nome da frente/squad. Ex: `NJS-APP-Login`, `NTS-Common-DigitalParking`.
- **`lambda-profile-env`** — código(s) da frente de destino, maiúsculas, um por linha.
- **`deploy.json` por função** (o nome do arquivo é parâmetro da action):

```json
{
  "FunctionName": "NTS-App-Fintech-StateMachine-PlanChange",
  "Projeto": "NTS-App-Fintech-StateMachine",
  "UsaVPC": "Sim",
  "Release": "1.0.15",
  "Configuration": {
    "Runtime": "nodejs20.x",
    "Handler": "index-plan-change.execute",
    "Timeout": 60,
    "MemorySize": 256,
    "Environment": { "Variables": { "LOG_LEVEL": "FULL" } }
  },
  "ReservedConcurrentExecutions": { "ReservedConcurrentExecutions": 100 },
  "Tags": { "Tags": { "obs": "descrição" } },
  "SQS_Trigger": {
    "EventSourceArn": "arn:aws:sqs:sa-east-1:#awsId:FILA",
    "Enabled": true,
    "BatchSize": 1
  }
}
```

- **Arquivos por operação** (parâmetro `operacao` da action determina qual é validado):
  - `configuracao` → `scriptsAws/config.json`
  - `trigger` → `scriptsAws/s3Trigger.json`
  - `concurrency` → `scriptsAws/reservedConcurrentExecutions.json`
  - `sqs` → `scriptsAws/sqsTrigger.json`
  - sempre obrigatório → `scriptsAws/tags.json`

### ⚠️ ACHADO CRÍTICO: a esteira de Lambda só suporta Node.js

**Confirmado por leitura do código**, não por documentação. Não é configurável — é estrutural:

| Arquivo | Evidência |
|---|---|
| `prepare-pipeline/install-dependencies` | `npm install` fixo. Sem detecção de linguagem, sem `pip`, sem `requirements.txt` |
| `test/unittest` | `npm run test --if-present`. Sem `pytest` |
| `build/action.yml` (Pré Build) | `npm install --omit=dev` |
| `build/action.yml` (Build) | `node awsDeploy.js <arquivo>` — **exige um script Node no repositório** para gerar os JSONs de deploy |
| `build/action.yml` (Zip Artifacts) | `if NJS … elif NTS …` **sem `else`** — repo que não seja NJS/NTS **não gera zip nenhum** e o job segue sem erro aparente |
| PATH do runner | Exporta só `node`, `maven`, `jdk`. Python não está no PATH |

```bash
# build/action.yml — trecho real
if [[ ${{ github.repository }} =~ "NJS" ]]; then
    zip -r ...
elif [[ ${{ github.repository }} =~ "NTS" ]]; then
    zip -r ...
fi
# ← não existe else
```

**Implicação para qualquer projeto Python:** não há caminho de adaptação do lado do consumidor. Ou o DevOps estende a esteira, ou o projeto precisa de outra estratégia de deploy. *(A doc oficial cobre Node, Java e Golang — cada um com seu template. Não há template Python para Lambda.)*

### Erros comuns documentados

- `AccessDenied` / `AccessDeniedException` em `sts:GetCallerIdentity` ou `lambda:GetFunction` → falta permissão na role, resolver com time de Cloud.
- `ResourceNotFoundException: Function not found` → geralmente inofensivo (validação prévia; a função é criada se não existir). Se a função *deveria* existir, conferir se o nome bate com o da AWS.
- `InvalidParameterValueException: provided execution role does not exist` → role inexistente **ou** SG/Subnet com número excessivo de IDs.

### ⚠️ Limitação de rede (causa raiz de incidente real)

`UsaVPC` é **booleano** — dá para dizer "usa VPC", mas **não qual subnet/SG**. Foi exatamente isso que causou o incidente das 50+ Lambdas subidas na VPC errada no projeto Carvalt/Afinz (ver [[30-06-2026]]). **Em qualquer projeto que use a esteira de Lambda com VPC, a infra precisa validar a subnet resolvida depois do deploy.**

---

## 6. S3 (`pipeline-s3.yml`)

### ⚠️ ACHADO: essa esteira NÃO cria bucket

Comum assumir que "S3 é esteira" significa "criação de bucket passa pela esteira". **Não é.** O que o código faz:

```bash
aws s3 sync ${dir} s3://${bucket} --profile ${profile}
aws s3 cp  ${dir} s3://${bucket} --recursive \
    --include "*.js" --include "*.css" --include "*.html" --include "*.txt"
```

É **publicação de conteúdo estático** (front-end) em bucket que já existe, com invalidação de CloudFront depois. Não cria bucket, não configura versionamento, não define policy, não define encryption.

**Consequência prática:** buckets de dados/infra (state, documentos, artefatos) provavelmente **não** são caso de uso dessa esteira e podem seguir por Terraform. Confirmar caso a caso, mas não assumir bloqueio automático só porque "é S3".

---

## 7. SQS & DynamoDB (`pipeline-awsproducts.yml`)

- Roda no **mesmo repositório das APIs** (workflow identificado como "AWS-Products").
- **Estrutura de pastas obrigatória**: `Dynamo/` e/ou `Sqs/` na raiz → subpasta por frente (ex: `CPP/`) → arquivo `generate.formation.js` + arquivos de definição de cada tabela/fila.
- **Profile**: `dynamo-profile-env` / `sqs-profile-env` com as frentes de destino.
- **Parâmetros da action**: Produto (Dynamo|SQS), Diretório (a frente), Arquivo (nome sem o prefixo `table.`/`sqs.` e sem `.json`), Release, Versionar.
- **Geração**: `node generate.formation.js <conta>/<produto>.<arquivo>` → produz `<arquivo>.output.json` e `<arquivo>.tags.output.json`.
- **DynamoDB via esteira cria apenas as tabelas**, não a stack em volta — proteção deliberada contra falha de processo apagar tabela.
- ⚠️ Executar **um produto por vez** se o repo tiver Dynamo e SQS — o workflow é único e pode dar conflito.

---

## 8. Criação de novos projetos (`create-project.yml`)

Automatiza: criação do repo GitHub → permissões/branch protection → SonarQube → namespaces OpenShift (`{frente}-dev|qa|pprd|prd`) → ArgoCD sync.

**Padrões de nomenclatura por tecnologia** (validados pela pipeline, falha se não bater):

| Tecnologia | Prefixo |
|---|---|
| Lambda | `NJS*` ou `NTS*` |
| Java | `ms*` |
| Tomcat | `tomcat*` |
| Angular | `ang*` ou `rjs*` |
| React MicroFrontend | `rnm*` |
| Python | `py*` |
| Node | `nst*` ou `nod*` |
| Golang | `go*` |
| Testes automatizados | `automation*` |
| Ionic | `IONIC*` |

**Permissões criadas**: DEV_TEAM=push, TECH_LEAD=maintain, DEVOPS/ARQUITETURA/OPERACOES=maintain. Branch protection em `master`/`release`/`develop` com 1 aprovação mínima + code owner review. Environments: QA sem reviewers; PRD/PPRD/FALLBACK com reviewers do time OPERACOES.

**Parâmetros de entrada**: `chamado` (RITM), `organization`, `projectname`, `frente`, `tecnologia`, `template-pipeline`, `container` (bool), `arquitetura` (bool), `sem-estrutura` (bool), `port`.

---

## 9. Checklist para entrar na esteira (qualquer projeto novo)

1. **Confirmar que a linguagem é suportada** pela pipeline alvo (ver §5 — Lambda é Node-only).
2. **Repositório criado com o prefixo correto** (§8) — via chamado, usando `create-project.yml`.
3. **`main.yml`** no repo do projeto chamando o template remoto (§1).
4. **Arquivo de profile** (`lambda-profile-env` etc.) com o código da frente.
5. **Arquivos de config** por recurso (`deploy.json`, definições de fila/tabela).
6. **GitHub Environment** configurado com a role AWS (feito pelo DevOps).
7. **Validar pós-deploy** o que a esteira não deixa controlar — principalmente **subnet/SG das Lambdas em VPC** (§5).

---

## Ver também

- [[Processos DevOps - chamados, fluxos, acessos e times]] — **governança em volta das pipelines**: tipo de chamado, Gitflow, DevOps Change, rollback, acessos via Sailpoint e quem procurar em cada time
- [[2026-07-02_chatbot-gringo-zendesk-agentcore]] — projeto que motivou o levantamento; contém o caso de uso aplicado
- [[30-06-2026]] — incidente das 50+ Lambdas na VPC errada (causa raiz: limitação `UsaVPC`)
- Repo de documentação: `SemParar-Alm/devops_documentation` (privado)
- Repo de templates: `SemParar-Alm/templates-pipelines-actions` (privado)
- Repo de referência Terraform: `SemParar-Alm/fleetcorbr-aws-repo-iac` (privado)
