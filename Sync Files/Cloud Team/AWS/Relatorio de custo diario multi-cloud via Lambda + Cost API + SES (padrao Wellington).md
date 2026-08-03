---
tags: [aws, lambda, ses, cost-explorer, finops, oci, azure, runbook, padrao-multi-cloud]
status: ativo
---

# Relatório de custo diário multi-cloud via Lambda + Cost API + SES (padrão Wellington)

> [!info] Quando usar
> Sempre que precisar de um **e-mail diário automático de custo/FinOps** de qualquer provedor de nuvem (AWS, OCI, Azure, GCP...) entregue para caixas `@corpay.com.br`, sem depender de infra dentro da rede corporativa. O padrão foi criado por **Wellington** para AWS (`finops-daily-report`), replicado por **Felipe** para **OCI** (`oci-bucket-cost-daily`) em 2026-07-15, e é o modelo a seguir para **Azure** (próximo passo planejado). Este documento existe para que qualquer pessoa — ou qualquer IA sem contexto prévio — consiga reproduzir o padrão para um provedor novo sem precisar re-descobrir as decisões abaixo.

## Por que este padrão existe (contexto)

A primeira tentativa (para OCI) foi rodar o script **localmente**, numa máquina dentro da rede Corpay, enviando e-mail via **relay SMTP interno** (`relay.corpay.com.br:25`, sem TLS/auth, filtra por IP de origem). Motivo: o relay só aceita conexões de dentro da rede.

Essa abordagem tinha dois problemas sérios:
1. **Precisa de uma máquina sempre ligada** dentro da rede (ninguém queria manter isso).
2. A porta 25 estava **bloqueada/filtrada** de saída na máquina de teste — nunca se conseguiu validar de fato.

A solução foi descobrir que **o Wellington já resolvia exatamente esse problema para AWS**, rodando 100% dentro da nuvem (Lambda + EventBridge), sem depender de nenhuma máquina física, entregando via **Amazon SES** (que sai da AWS e entrega direto no MX da Corpay — sem tocar rede interna nem porta 25). Reaproveitar essa estrutura pra outros provedores de nuvem é estritamente melhor: zero infra própria pra manter.

## Arquitetura (genérica, vale para qualquer provedor)

```
EventBridge (schedule cron, ex.: 08:45 BRT)
        │
        ▼
Lambda (Python 3.12, x86_64, ~512MB / 2min timeout)
        │  role IAM com:
        │    secretsmanager:GetSecretValue  (credencial do provedor de nuvem)
        │    ses:SendRawEmail / ses:SendEmail
        ▼
API de custo do provedor  (Cost Explorer / Usage API / Cost Management...)
        │  monta HTML (tabelas, email-safe, sem CSS externo)
        ▼
Amazon SES  (send_raw_email, From verificado)
        ▼
Destinatários @corpay.com.br (cada um precisa estar VERIFICADO no SES, ver seção Sandbox)
```

**Conta AWS onde tudo isso vive:** `898720776429` — é a conta **payer/management da organização Corpay** (confirmado via `aws organizations describe-organization --query Organization.MasterAccountId`), região **`sa-east-1`** (São Paulo). Não é a conta operacional `867102406853` nem a `corpay-infra` (`498638359097`) — essas não têm as identidades SES nem as Lambdas de relatório.

Perfil AWS CLI local (SSO) para essa conta: `BR_PS_CLOUD-898720776429`, sessão `Corpay` (start URL `tulamben.awsapps.com`).

## Exemplo de referência: `finops-daily-report` (Wellington, AWS)

- Lambda `finops-daily-report`, Python 3.12, role `finops-daily-report-role`
- Trigger: EventBridge rule `finops-daily-report-17h`, `cron(0 20 * * ? *)` = 17h BRT
- Coleta: **Cost Explorer**, sempre em `us-east-1` (é a única região onde a API `ce:*` responde, independente de onde os recursos estão)
  - `ce_get_cost()` chama `get_cost_and_usage` com paginação (`NextPageToken`)
  - Granularidade MONTHLY/DAILY, `GroupBy` por conta/serviço via `organizations:ListAccounts`
- Envio: `boto3.client("ses").send_raw_email(...)`, `SENDER_EMAIL=cloudteam@corpay.com.br`
- Permissões IAM (inline policy `finops-permissions`):
  ```json
  ["ce:GetCostAndUsage", "ce:GetCostForecast", "ce:GetDimensionValues"]
  ["organizations:ListAccounts", "organizations:DescribeAccount"]
  ["ses:SendRawEmail", "ses:SendEmail"]
  ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
  ```
- Design do e-mail: header escuro (`#0F172A`), 3 cards (mês acumulado / dia anterior / projeção fim do mês com faixa piso-teto), badge de status (NORMAL/ATENÇÃO/REDUÇÃO), barra de progresso do mês, gráfico de barras em tabela (email-safe), seção de anomalias e recomendações, gráfico via `matplotlib` anexado como imagem inline (`Content-ID`).

## Implementação replicada: `oci-bucket-cost-daily` (Felipe, OCI)

Mesma arquitetura, trocando só a fonte de dados e a autenticação:

- Lambda `oci-bucket-cost-daily`, Python 3.12, x86_64, 512MB, timeout 2min
- Trigger planejado: EventBridge cron `08:45 BRT` (`cron(45 11 * * ? *)`) — ver seção "Decisão: horário de envio" abaixo
- Coleta: **OCI Usage API**, operação `request_summarized_usages`, granularidade DAILY, `query_type=COST`, filtrando pela dimensão `resourceId = <namespace>/<bucket>` (para Object Storage; para outros tipos de recurso o formato do resourceId muda — usar o OCID normal quando não for bucket)
- **Home region obrigatória:** a Usage API só responde na **home region da tenancy** (aqui, `sa-saopaulo-1`), mesmo que o recurso monitorado esteja em outra região (aqui, o bucket está em `sa-vinhedo-1`). Fora da home region, dá `403 NotAllowed: "Please go to your home region to execute this operation"`. O código força a region do client OCI para a home region independentemente de onde outros recursos estão.
- Credencial OCI: **Secrets Manager**, secret `oci/cost-monitor/api-key` (ARN em `arn:aws:secretsmanager:sa-east-1:898720776429:secret:oci/cost-monitor/api-key-*`), JSON com `user`, `tenancy`, `fingerprint`, `region`, `private_key`. A Lambda lê o secret em runtime e escreve a chave em `/tmp/oci_api_key.pem` (único diretório gravável no ambiente Lambda).
- Role: `oci-bucket-cost-daily-role-0uzmj0p7` + inline policy `oci-cost-secret-and-ses`:
  ```json
  { "Effect": "Allow", "Action": "secretsmanager:GetSecretValue",
    "Resource": "arn:aws:secretsmanager:sa-east-1:898720776429:secret:oci/cost-monitor/api-key-*" },
  { "Effect": "Allow", "Action": ["ses:SendRawEmail", "ses:SendEmail"], "Resource": "*" }
  ```
- `SENDER_EMAIL=cloudteam@corpay.com.br` (mesma identidade já verificada do Wellington — reaproveitada, não precisou verificar identidade nova)
- Design do e-mail: adaptado para paleta **Oracle Redwood** (`#C74634` vermelho, header `#312D2A`), mesma estrutura de cards/badge/progresso, mais uma seção específica de **simulação de classes de armazenamento** (Standard/Infrequent Access/Archive) — ver "Decisões de produto" abaixo.

## Passo a passo genérico (para replicar num provedor novo, ex. Azure)

Todo o processo abaixo foi feito **pelo console AWS** (decisão do Felipe: preferir clicar a rodar CLI, para fins de aprendizado). Só o empacotamento do `.zip` (que envolve compilar dependências nativas para Linux) foi feito via terminal, porque não tem equivalente no console.

### Fase 1 — Verificar o(s) e-mail(s) de teste no SES
SES → Identities → Create identity → Email address → confirma no link recebido. **Todo destinatário precisa estar verificado enquanto a conta SES estiver em sandbox** (ver seção Sandbox).

### Fase 2 — Guardar a credencial do provedor no Secrets Manager
Secrets Manager → Store a new secret → Other type of secret → aba Key/value com os campos necessários (para OCI: user/tenancy/fingerprint/region/private_key; para Azure seria: tenant_id/client_id/client_secret/subscription_id). Copiar o **Secret ARN** gerado.

### Fase 3 — Empacotar o código com dependências Linux (a parte "chata", só via terminal)
O SDK de custo de cada provedor (`oci`, `azure-mgmt-costmanagement`, etc.) normalmente traz dependências com **código nativo compilado** (ex.: `cryptography`), que precisam ser wheels **Linux x86_64**, mesmo desenvolvendo em máquina Windows — o pip local instala a wheel do SO local, que não roda no Lambda.

```powershell
python -m pip install --platform manylinux2014_x86_64 --implementation cp --python-version 3.12 `
  --only-binary=:all: --target package <pacote-do-sdk>
Copy-Item lambda_function.py package\
cd package; python -c "import shutil; shutil.make_archive('../function','zip','.')"
```

Limite de **50 MB para upload direto pelo console** (acima disso, precisa subir via S3 primeiro). O pacote do SDK `oci` deu **40,4 MB zipado / 219 MB descompactado** — dentro do limite, mas por pouco. SDKs de Azure tendem a ser mais leves.

### Fase 4 — Criar a Lambda
Console → Lambda → Create function → Author from scratch → Python 3.12 → **arquitetura x86_64** (mesma da wheel usada na Fase 3 — se usar ARM64 aqui, o zip não roda) → Create function → Code → Upload from → .zip file.

### Fase 5 — Configurar
- Configuration → General configuration: Timeout ~2min, Memory ~512MB (import de SDKs grandes estoura o timeout/memória padrão)
- Configuration → Environment variables: ARN do secret, e-mails remetente/destinatário, labels do recurso monitorado

### Fase 6 — Permissões
Configuration → Permissions → clicar no Role → Add permissions → Create inline policy → JSON com `secretsmanager:GetSecretValue` (escopado ao ARN do secret) + `ses:SendRawEmail`/`ses:SendEmail`.

### Fase 7 — Testar
Aba Test → Create new event → `{}` → Test. Ver `Execution result: succeeded` e conferir e-mail (e Junk/Lixo Eletrônico no primeiro envio). Erros aparecem no CloudWatch Logs (link direto no resultado do teste).

### Fase 8 — Agendar
Add trigger → EventBridge (CloudWatch Events) → Create a new rule → Schedule expression `cron(...)` em **UTC** (BRT = UTC−3).

## Gotchas importantes (não óbvios, custaram tempo para descobrir)

1. **Sandbox do SES:** a conta `898720776429` está com `ProductionAccessEnabled: false`. Nesse modo, o SES só entrega para **destinatários verificados individualmente** como identidade (`sesv2 list-email-identities` mostra quem já está liberado). Antes de qualquer go-live com lista de distribuição ampla (ex.: `cloudteam@corpay.com.br` como grupo, não caixa única), é preciso pedir **production access** ao SES — senão o envio silenciosamente não chega para quem não estiver verificado.

2. **Zscaler intercepta TLS na rede Corpay** — isso só afeta quem roda o SDK/CLI **localmente numa máquina da empresa** (não afeta a Lambda, que roda fora dessa rede). Se for testar localmente antes de subir pra Lambda, ver nota [[Zscaler CA bundle para OCI CLI e SDK]] — resumo: monta um CA bundle combinando `certifi` + a cadeia de certificados capturada via `openssl s_client -showcerts` do endpoint alvo, e aponta `REQUESTS_CA_BUNDLE`/`--cert-bundle` pra ele.

3. **Home region / região fixa da API de custo:** várias APIs de billing só respondem numa região específica, independentemente de onde o recurso monitorado está (AWS Cost Explorer → sempre `us-east-1`; OCI Usage API → sempre a home region da tenancy). Isso não é intuitivo e gera 403/erro de permissão que parece ser de auth mas é de região. Ao portar para Azure, checar se `Microsoft.CostManagement` tem uma restrição parecida (não parece ter — a API aceita escopo por subscription/resource group diretamente).

4. **`ARN`/`Architecture` da Lambda precisa bater com a wheel:** se a wheel foi baixada `manylinux2014_x86_64` mas a Lambda foi criada como `arm64`, o import de módulo nativo falha em runtime com erro de formato de binário. Conferir a arquitetura ANTES de subir o zip.

5. **Dado "hoje" é sempre parcial:** APIs de custo agregam com atraso (~24h típico). Se o schedule roda de manhã, o "dia de hoje" no relatório fica artificialmente baixo (ainda não fechou). **Decisão adotada:** cortar a coleta em "dias completos" (até ontem), nunca incluir o dia corrente parcial — evita o gestor interpretar uma queda de custo que na verdade é só o dado ainda não ter chegado.

## Decisão: horário de envio

Cogitou-se enviar às 23:59 (para "pegar o dia fechado"), mas isso **não resolve** o problema do atraso de agregação — o dado de hoje-quase-meia-noite ainda estaria incompleto do mesmo jeito. A solução correta foi **sempre reportar até o último dia completo (ontem)**, independente do horário de envio, e escolher o horário só pensando em UX de notificação: enviar de manhã (~08:45 BRT, antes do gestor abrir a caixa por volta das 9h) garante que a notificação apareça no topo da caixa quando ele for checar, sem ficar enterrada numa madrugada.

## Decisões de produto (específicas do relatório OCI, mas o padrão vale)

O relatório não é só "quanto custou" — inclui contexto de negócio extraído de um deck de proposta (`Redução de custos bucket OCI`, jul/2026):
- O bucket `oracle-cgmp3-backups` (323 TB) é o **único backup/DR** de um storage on-prem (DC1) que queimou; DC2 assumiu a operação mas está sem proteção própria.
- Existe uma proposta pendente de mudar a classe de armazenamento de **Standard → Archive**, economia estimada de **~R$ 465 mil/ano (90%)**.
- O relatório inclui uma seção de **simulação das 3 classes** (Standard atual / Infrequent Access / Archive) usando a projeção do mês corrente, para manter essa decisão visível ao gestor diariamente sem precisar cobrar manualmente.
- Detecção de "dia atípico" (>10% acima da média móvel de 7 dias) destaca a barra do gráfico em vermelho e soma uma frase de insight no topo do e-mail — o objetivo é que o gestor entenda o dia em uma frase, sem precisar interpretar a tabela.

Esse padrão de "conectar o relatório de custo a uma decisão de negócio pendente" vale para qualquer nuvem: sempre vale perguntar "existe uma proposta/otimização parada que este e-mail poderia manter viva?" antes de simplesmente clonar o template.

## Para replicar em Azure (próximo passo, ainda não feito)

- API: **Cost Management** (`azure-mgmt-costmanagement`), operação de query com escopo por subscription (`/subscriptions/{id}`) ou resource group (`/subscriptions/{id}/resourceGroups/{rg}`)
- Autenticação: **Service Principal** (tenant_id/client_id/client_secret), papel mínimo `Cost Management Reader` no escopo desejado — análogo à chave de API OCI/usuário read-only
- Equivalente de "conta" (para agrupamento, como o `LINKED_ACCOUNT` do Cost Explorer): **subscription**; dentro dela, **resource group** é o equivalente mais granular a um "compartment" da OCI
- Resto do pipeline (Lambda, Secrets Manager, SES, EventBridge) é idêntico — só troca a Fase 3 (SDK a empacotar) e a lógica de coleta

## Referências
- [[Zscaler CA bundle para OCI CLI e SDK]] (gotcha de rede, só relevante para testes locais)
- `HANDOFF.md` no repositório `oci-cost-monitor` (histórico da migração do relay SMTP interno para Lambda+SES — não versionado neste vault)
- Deck de contexto: `Redução de custos bucket OCI` (jul/2026) — proposta de migração Standard→Archive
