---
tags: [aws, terraform, bedrock, agentcore, zendesk, chatbot, projeto-novo]
date: 2026-07-02
cluster/resource: "conta Zapay DEV 538311878212 (sa-east-1) — VPC vpc-chatbot-dev"
status: em andamento
---

# Chatbot Gringo (Zendesk + Bedrock AgentCore) — infra AWS

> [!info] Contexto
> Projeto de migração de um chatbot (cliente/integração "Gringo") para AWS, usando Zendesk como canal de atendimento e AWS Bedrock AgentCore como orquestrador de agentes de IA. Felipe é ponto focal técnico (definido por Claudio), Francisco construiu a infra do zero como piloto em conta limpa. Wellington e Isaelin (Cloud/DevOps) estão envolvidos na governança (esteira vs. Terraform livre).

## Pessoas

- **Claudio Henrique Menezes Delgado Toscano de Brito** — definiu Felipe como ponto focal técnico (HML/PRD). Aguardando ID do projeto no ServiceNow.
- **Francisco Lucas Rodrigues de Sousa** — construiu toda a infra AWS do zero (VPC até integrações) numa conta limpa, sem conhecer as convenções do time.
- **Wellington** — Cloud/DevOps, alinhando arquitetura, esteira e rede com Felipe.
- **Isaelin Claudino dos Santos = "Zaza"/"Zazinho"** (mesma pessoa — apelido confirmado por ele mesmo na call de 20/07) — DevOps, orienta Francisco e confirma o que é esteira vs. Terraform.
- **Marcia Beatriz Pereira Domingues ("Bia")** — revisão de arquitetura, levanta pontos de resiliência/DLQ, observabilidade e compliance/PCI.
- **Gustavo Henrique Moura Spindola** — dev do lado Gringo junto com Francisco, cuida da parte interna do AgentCore (chamadas externas, logs, timeouts) e do uso do DynamoDB.
- **Rafael Humberto ("Rafa")** — acionado por Francisco para resolver domínio/certificado; também envolvido na questão de compliance/PCI do projeto.
- **Amanda** — testadora, usa o ambiente DEV (que hoje também faz papel informal de homolog).
- **Guilherme (sobrenome incerto: "Chavenko"/"Chameco") e um segundo "Lucas" (DevOps/Cloud)** — vão dar suporte nas pipelines de container/ECR. Atenção: Francisco também é chamado de "Lucas" pelo time (nome do meio) — são pessoas diferentes.

## Arquitetura

Zendesk ↔ Imperva (WAF/proteção, escopo time SI) ↔ Amazon API Gateway (REST, domínio por ambiente — padrão definitivo `chatbot.api.<env>.semparardoc.com.br`: DEV `chatbot.api.dev.semparardoc.com.br` **criado, validado e ativo em 14/07/2026**; stage/prod ainda a criar, seguir o mesmo padrão) → Lambda Worker → SQS → Lambda Adapter (REST/A2A) → **AgentCore Runtime** (orquestrador) → ElastiCache Redis (sessão) + DynamoDB (contexto) + Bedrock Knowledge Base (S3 + OpenSearch Serverless, embeddings Titan G2) → sub-agentes (protocolo A2A) → Lambda Integration-Zendesk (API Sunshine, credenciais via Secrets Manager) → volta pro Zendesk/Analyst.

Camadas auxiliares: Guardrails (Bedrock Invoke Model/Guardrails), Knowledge Base Layer (OpenSearch + S3), Permission Layer (AgentCore Identity → Cognito).

Também existe um módulo WAF (WAFv2) **de fato deployado** na conta, associado ao API Gateway (Web ACL `worker-api-dev`) — Common Rule Set + Known Bad Inputs + IP Reputation + rate limit 2000 req/5min por IP. Não confundir com o Imperva, que fica antes na cadeia (SI).

## Governança — Esteira vs. Terraform

- **✅ CONFIRMADO AO VIVO na call de 20/07/2026 (Isaelin/Zaza presente, confirmou explicitamente):** esteira = **SQS, Lambda, API Gateway, S3 e DynamoDB**. Tudo o mais (ElastiCache, Bedrock/AgentCore/Knowledge Base, ECR, VPC, Secrets Manager) sobe via Terraform/"plataforma", em DEV/QA/PROD. Essa é a lista definitiva — havia divergência entre versões anteriores ditas pelo Wellington e pelo Isaelin, resolvida nessa reunião.
  - SQS via esteira = fila padrão, sem parâmetros especiais (ajustável se precisar).
  - DynamoDB via esteira = só cria as tabelas, não cria stack em volta (proteção contra falha de processo apagar tabela sem querer).
- Existe uma esteira real conhecida chamada **Medâne** (deploy de Lambda) — limitação conhecida: só permite flag genérica "usa VPC" sem controle granular de subnet (causou incidente real com 50+ Lambdas na VPC errada no projeto Carvalt/Afinz).

## Domínio DEV — processo executado (14/07/2026, Felipe + Lucas)

Runbook do que foi feito para criar `chatbot.api.dev.semparardoc.com.br` (serve de modelo para stage/prod — passo a passo genérico também em [[Criar dominio customizado para API Gateway (ACM + Route53)]]):

1. **Certificado ACM** na conta do ambiente (DEV `538311878212`, sa-east-1) para o FQDN — validação DNS (CNAME), aguardar status Issued. ARN: `...certificate/91711ee1-9766-4baa-bec5-6272715dd7b2`.
2. **Custom Domain Name** no API Gateway (mesma conta/região), endpoint Regional, TLS 1.3, associado ao certificado — a AWS gera um target `d-xxxxxxxxxx.execute-api.sa-east-1.amazonaws.com`.
3. **API mapping**: domínio custom → API `worker-api-dev`, stage `dev`. Confirmado que a mesma API+stage pode ter mapping em múltiplos Custom Domain Names ao mesmo tempo, sem conflito — útil se precisar corrigir nome depois sem downtime.
4. **DNS**: a zona pública `semparardoc.com.br` fica no **Route 53 da conta Infra `498638359097` (org Corpay)** — hosted zone `Z074611014ZD10SL5YBS`. Criar 2 CNAMEs: o de validação do ACM e o FQDN → target do Custom Domain (nunca apontar direto pra URL `execute-api` da API — quebra a validação TLS do certificado).
5. **✅ Validado via AWS CloudShell**: `POST /webhook` retornou `202 {"status": "queued", ...}` — TLS ok, cadeia completa funcionando até a Lambda Worker.

> [!info] Histórico de correção de nome
> Primeira tentativa criou `chatbot.dev.api.semparardoc.com.br` (env antes de "api", batendo com o texto literal do chamado). Felipe percebeu a divergência com o padrão documentado pelo Rafael Humberto (`chatbot.api.<env>...`) e corrigiu: criou tudo do zero com o nome certo (ACM não permite renomear) e **descomissionou completamente** o nome antigo (CNAMEs, Custom Domain, certificado). **Nome definitivo e único hoje: `chatbot.api.dev.semparardoc.com.br`.**

> [!warning] Padrão para stage/prod
> Usar o mesmo formato: `chatbot.api.stage.semparardoc.com.br` e `chatbot.api.semparardoc.com.br` (prod, conforme lista original do Rafael Humberto). Confirmar o nome com a equipe *antes* de criar o certificado ACM, já que corrigir depois exige recriar tudo do zero.

## Rede — plano de correção do CIDR

VPC `vpc-chatbot-dev` (`vpc-00dece0c46f17bcdd`) foi criada por Francisco **sem passar pelo processo de alocação de bloco CIDR do time de Network** — CIDR atual `10.4.0.0/16`. Toda VPC nova da empresa deveria vir de um bloco solicitado ao Network, para evitar overlap com integrações futuras (ex: on-premises).

**✅ Blocos aprovados (TASK1256406, aprovado por Enio, informado por Thiago Ribeiro em 14/07/2026):**

| Ambiente | Conta AWS | CIDR |
|---|---|---|
| DEV | 538311878212 | `10.18.198.0/24` |
| QA | 487442499837 | `10.18.199.0/24` |
| PROD | 110661053019 | `10.18.200.0/24` |

⚠️ Cada bloco é `/24` (256 IPs) — o desenho original de subnets do Francisco (privadas `/22`) **não cabe**. As 4 subnets precisam ser redesenhadas (sugestão: 4× `/26`).

**Estratégia de migração acordada (evita travar o destroy por ENIs anexadas):** subir a VPC nova em paralelo com o CIDR aprovado (outro nome/state, sem tocar na `vpc-chatbot-dev`), reapontar cada stack dependente (Lambdas atualizam in-place, SGs/subnet group do Redis são recriados — API Gateway e ARNs de Lambda não mudam), e só destruir a VPC antiga depois de validar tudo na nova.

**⚠️ Pegadinha confirmada na revisão do código:** as 4 CIDRs de subnet (`modules/vpc/variables.tf`) são defaults hardcoded independentes, **não derivadas de `var.vpc_cidr`** via `cidrsubnet()`. Trocar só o CIDR da VPC não move as subnets — as 4 variáveis precisam ser recalculadas manualmente e em conjunto antes do apply, senão quebra (subnet fora do range da VPC).

## Diagnóstico de estado real (via AWS CLI, conta 538311878212, sa-east-1, 2026-07-02)

Revisão do código Terraform (`iac/` recebido de Francisco, zip local) cruzada com o estado real da conta:

| Item | Status |
|---|---|
| WAF | ✅ Live, associado às stages `dev` e `tests` do API Gateway — código bate com a realidade |
| NAT Gateway | ✅ Live (`nat-094a8e029a7ecd3bb`), single-AZ, EIP atual `54.207.32.136` — **vai mudar ao recriar a VPC**, checar dependências downstream (ex: allowlist de IP na Sunshine API do Zendesk) |
| VPC/subnets | ✅ Zero drift — CIDR e as 4 subnets batem exatamente com o Terraform |
| DynamoDB | ⚠️ **Drift confirmado** — 3 tabelas fora do Terraform: `ggo-chatbot-ia-v2-core` (392 itens), `-events` (33 itens, criada 2026-06-30), `-surveys` (13 itens) — parecem pertencer a outro projeto/squad usando a mesma conta. Não gerenciadas pelo Terraform de Francisco; confirmar dependência de rede antes de destruir a VPC |
| Terraform state bucket | ✅ `corpay-chatbot-terraform-state` ativo, 391 versões de objeto — states reais de `dev/*` (10 componentes) e `tests/*` (6 componentes, reaproveitando network/repository-image-runtime do dev) |
| Lock table | ✅ `terraform-state-locks` (DynamoDB), 7 itens, ACTIVE — não está vazia |
| `env/tests` | ✅ **Aplicado de verdade**, não é só código — tem API Gateway (`worker-api-tests`), Lambdas, SQS, DynamoDB, WAF, AgentCore runtime próprio (`chatbot_agentcore_tests`, v5, READY) |
| `knowledge-base-managed` (módulo) | ❌ Código morto confirmado — nunca foi deployado (nenhum OpenSearch domain clássico na conta), sem custo. Pode ser removido do repo com segurança. `knowledge-base-serverless` é o realmente usado (collection `test-chatbot-kb-dev`, ACTIVE — nome com prefixo `test-` mesmo em dev, confirmar com Francisco se é intencional) |
| Recursos hand-created fora do Terraform | 2 security groups gerados pelo wizard "Connect via CloudShell" do console (`elasticache-cloudshell-*`, `cloudshell-elasticache-*`) + 1 Lambda `redis-teste` (sem tags, criada 2026-07-01, reutiliza a IAM role do `adapter-rest-a2a-dev`) — sinal de alguém mexendo direto no console |

### Inventário geral (conta 538311878212)

- **VPC**: `vpc-00dece0c46f17bcdd` (vpc-chatbot-dev), 4 subnets, 1 IGW, 1 NAT
- **Lambdas**: `integration-zendesk-dev`, `worker-dev`, `adapter-rest-a2a-dev` + equivalentes `-tests`, `redis-teste` (manual)
- **SQS**: `adapter-rest-a2a-queue`, `adapter-rest-a2a-queue-tests`
- **ElastiCache**: `chatbot-redis-dev` (cache.t4g.micro, Redis 7.0.7, single-node, **sem encryption at rest/transit, sem AUTH token**)
- **DynamoDB**: `chat-sessions-dev/tests`, `chat-surveys-dev/tests`, `terraform-state-locks` + drift `ggo-chatbot-ia-v2-*`
- **S3**: `corpay-chatbot-terraform-state`, `corpay-chatbot-lambda-artifacts`, `chatbot-kb-documents-dev`, `bedrock-agentcore-runtime-...`, `cdk-hnb659fds-assets-...`, `seguro-assistencia` (outro projeto na mesma conta)
- **ECR**: `chatbot-agentcore-repo`, `cdk-hnb659fds-container-assets-...`
- **Bedrock AgentCore runtimes**: `chatbot_agentcore_dev` (v20, READY), `chatbot_agentcore_tests` (v5, READY), `chatbotOrchestrator_chatbotOrchestrator` (v8, READY)
- **OpenSearch Serverless**: `test-chatbot-kb-dev` (ACTIVE)
- **API Gateway**: `worker-api-dev`, `worker-api-tests`

## Pontos de segurança a revisitar antes de PROD (não bloqueiam DEV/QA)

- DynamoDB sem PITR nem KMS customizado
- ElastiCache Redis sem AUTH token, sem encryption in transit/at rest
- OpenSearch Serverless com `AllowFromPublic = true` (exposto à internet, mitigado só pela data access policy)
- API Gateway sem autenticação (`authorization = "NONE"`) — presumivelmente ok porque o Imperva filtra antes e a validação ocorre dentro da Lambda, mas vale confirmação explícita com Francisco
- Bucket de state (`corpay-chatbot-terraform-state`) tem nome flat único, não preparado para múltiplas contas — se DEV/QA/PROD forem contas AWS separadas, decidir agora um bucket de state por conta (padrão equivalente ao já usado no Azure, um state store por subscription/tier)

## Estrutura do código Terraform recebido de Francisco

Zip extraído localmente (`iac-v2/iac`), organizado por contexto (não por tipo de recurso):

```
iac/
├── env/
│   ├── dev/       (agents/runtime, memory/{cache,context-memory,knowledge-base,knowledge-base-serverless,surveys}, message-processing/{adapter-rest-a2a,integration-zendesk,message-ingestion}, platform/{backend,network,repository-image-runtime})
│   └── tests/     (aplicado de verdade na AWS, mas diverge de dev/ — falta memory/cache e platform/ inteiro; usados como placeholder de QA)
└── modules/
    (agentcore/runtime, api-gateway-rest, dynamodb, ecr, elasticache, knowledge-base-managed, knowledge-base-serverless, lambda, sqs, triggers/lambda-sqs, vpc, waf)
```

## Call de alinhamento 20/07/2026 — "Dúvidas ambientes de HML e PRD"

**Status confirmado:** DEV subido e testado. Próximo: QA — Francisco sobe a parte Terraform pareado com Felipe, alinha a parte esteira com DevOps (Guilherme/outro Lucas). Depois de QA validado com testes de estresse, decide caminho pra PROD.

**Pontos de resiliência levantados pela Bia (ação pendente):**
- Falta política de DLQ e retenção de mensagem no SQS — risco de perda de mensagem ou retry infinito se a Lambda Adapter travar sob estresse. Francisco vai alinhar isso com quem auxiliar no provisionamento da esteira.
- Reforçar observabilidade — Isaelin/Zaza sugeriu pilotar em QA com testes de estresse.
- Monitoramento: hoje 100% CloudWatch; **não decidido** se vai exportar também pra Dynatrace (usado internamente pelo time).
- Único ponto de comunicação externa real no fluxo é dentro do **AgentCore Runtime** — tudo antes disso (API Gateway → Worker → SQS → Adapter) é 100% interno/AWS-managed, sem chamada externa. Reduz a superfície de risco de travamento a só dentro do AgentCore (que já tem timeout, logs estruturados e fallback mapeados).

**Diagrama desatualizado (WAF vs. Imperva):** Felipe apontou que o desenho ainda mostra AWS WAF, mas na prática usam Imperva. Francisco confirmou ser resquício da primeira versão — **ação pendente: atualizar o diagrama**. Não ficou definido se o WAF module (confirmado deployado no DEV) será removido do Terraform ou mantido como camada extra.

**DEV fazendo papel duplo (dev + homolog informal):** a conta DEV também é usada informalmente como ambiente de teste pra "Amanda" (testadora), enquanto QA de verdade não existia. Cogitam converter o OpenSearch Serverless do DEV pra instância gerenciada (custo) mais pra frente.

**DynamoDB — propósito esclarecido:** 3 tabelas — 1 reservada pra sessão (uso futuro incerto), 2 pra tracking/eventos do bot (ajudam a recuperar contexto pros agentes). É solução **temporária** até o time de banco de dados da empresa ter estrutura própria pronta. Não usam Redis (volume/retenção) nem OpenSearch pra isso — propósito diferente (persistência/auditoria vs. cache de sessão).

**Compliance / PCI (novo):** Gringo está entrando nos modelos de auditoria PCI da empresa — vai precisar de rastreabilidade de mudanças (Changes). Hoje não tem o fluxo formal via ServiceNow que Sem Parar/Zapay usa. Bia sugeriu, no mínimo, uma tabela de changelog. Isaelin/Zaza vai alinhar com o Rafa sobre o escopo PCI e nível de Change necessário.

**Fluxo de aprovação pra PROD — em aberto:** cogitado PR aprovado por tech lead + code review como substituto ao Change/ServiceNow padrão, já que Gringo não tem esse fluxo. Não fechado.

**Conta AWS compartilhada Gringo/Zapay:** tecnicamente viável, mas dúvida sobre viabilidade burocrática/compliance (mesmo tema do PCI) — Bia/Rafa vão avaliar.

**Próximos passos consolidados (Isaelin/Zaza):**
1. Francisco sobe infra em QA (Terraform, pareado com Felipe).
2. Trazer código da aplicação (Lambdas) pro repositório oficial, com orquestração via AgentCore.
3. Criar pipeline de atualização via ECR (provavelmente 2: build/push de imagem + atualização do serviço AgentCore após subir imagem — padrão similar ao já usado em OpenShift/RKE/OKE).
4. Francisco alinha separadamente o fluxo de promoção/validação até produção.
5. Isaelin/Zaza conversa com Rafa sobre PCI/compliance do Gringo.

## Próximos passos (infraestrutura/rede)

1. ~~Felipe solicita blocos CIDR ao time de Network~~ ✅ feito, blocos aprovados (ver tabela acima).
2. Francisco destrói a VPC atual; recriação via Terraform com CIDR novo, recalculando as 4 subnets (estratégia: VPC nova em paralelo, não destroy-then-create).
3. Confirmar com quem criou as tabelas `ggo-chatbot-ia-v2-*` se há dependência de rede antes de destruir.
4. Felipe sobe o DEV pareado com o Francisco (call).
5. Código Terraform fica local até tudo funcionar em DEV/QA/PROD; só depois sobe pro GitHub da empresa (repositório a ser criado pelo time de DevOps).

---

*Nota mantida como log vivo — atualizar conforme o projeto evolui.*
