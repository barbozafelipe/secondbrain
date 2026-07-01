---
tags:
  - aws
  - zapay
  - organization
  - iam
  - sso
  - diagnóstico
date: 2026-06-16
account: perimetro-zapay
status: resolvido
---

# ZPY - Disambiguamento de contas Zapay + Setup de perfis SSO

## Contexto

A SSO session `zapay` (`https://d-946773ab8e.awsapps.com/start/#`) dá acesso a 14 contas. O perímetro Zapay tem 7 contas relevantes, mas apenas 2 tinham perfil CLI configurado. Objetivo: mapear todas as contas, descobrir roles disponíveis, e criar perfis CLI para as 5 contas faltantes.

## Diagnóstico

### Contas no perímetro Zapay (via `aws sso list-accounts`)

| Conta AWS | Account ID | Email | Perfil CLI |
|---|---|---|---|
| Zapay | 071032557399 | grupoawssempararti@corpay.com.br | `zapay` (existia) |
| zapay-staging | 901943060028 | grupoawssempararstg@corpay.com.br | `zapay-staging-sso` (existia) |
| Audit | 242201304053 | aws.zapay+audit@compasso.com.br | `zapay-audit` (criado) |
| Log Archive | 183295435188 | aws.zapay+log-archive@compasso.com.br | `zapay-log-archive` (criado) |
| ZapayPayer | 575108926897 | aws.zapay@compasso.com.br | `zapay-payer` (criado) |
| Olho no Carro | 865350113542 | datacenter@olhonocarro.com.br | `zapay-olho-no-carro` (criado) |
| zapay-production | 717354774649 | grupoawssempararprd@corpay.com.br | `zapay-prod` (criado) |

Todas as 5 contas novas têm a role `BR_PSAWSZPY_CLOUD` disponível via SSO Zapay.

### DESAMBIGUAMENTO CRITICO: "Zapay" vs "zapay-production"

| | Zapay (071032557399) | zapay-production (717354774649) |
|---|---|---|
| Perfil CLI | `zapay` | `zapay-prod` |
| EKS | `zapay-one` (v1.34, ACTIVE) | NENHUM |
| RDS | zapay-db-production (db.m6g.4xlarge), replica, etc | NENHUM |
| VPC | 192.168.0.0/16 (EKS-VPC), 10.0.0.0/16 (DMSVPC), 172.31.0.0/16 | 10.100.0.0/16 (vpc-production), 172.31.0.0/16 |
| EC2 | (confirmar) | NENHUMA |
| Lambda | (confirmar) | NENHUMA |
| Secrets Manager | (confirmar) | NENHUM |
| S3 | (confirmar) | `zapay-production-terraform-state` (apenas!) |
| Subnets | (confirmar) | 3 AZs (a/b/c), padrão Private/Public |

**Conclusao:** A conta "Zapay" (071032557399) e a producao REAL — tem EKS, RDS, toda a carga de trabalho. A conta "zapay-production" (717354774649) e uma conta VAZIA / em preparo que contem apenas VPC de rede provisionada e um bucket de Terraform state. Provavelmente destinada a uma futura migracao de workloads para uma conta dedicada de producao (separacao de contas), mas AINDA NAO tem carga de trabalho real.

**Uso correto dos perfis:**
- `--profile zapay` = workload de producao real (EKS, RDS, aplicacoes)
- `--profile zapay-prod` = conta vazia / infraestrutura futura (so VPC + TF state)

## Resolucao

### Perfis adicionados em ~/.aws/config

Todos reutilizam `sso-session zapay`, role `BR_PSAWSZPY_CLOUD`, region `sa-east-1`.

```ini
[profile zapay-audit]
sso_session = zapay
sso_account_id = 242201304053
sso_role_name = BR_PSAWSZPY_CLOUD
region = sa-east-1
output = json

[profile zapay-log-archive]
sso_session = zapay
sso_account_id = 183295435188
sso_role_name = BR_PSAWSZPY_CLOUD
region = sa-east-1
output = json

[profile zapay-payer]
sso_session = zapay
sso_account_id = 575108926897
sso_role_name = BR_PSAWSZPY_CLOUD
region = sa-east-1
output = json

[profile zapay-olho-no-carro]
sso_session = zapay
sso_account_id = 865350113542
sso_role_name = BR_PSAWSZPY_CLOUD
region = sa-east-1
output = json

[profile zapay-prod]
sso_session = zapay
sso_account_id = 717354774649
sso_role_name = BR_PSAWSZPY_CLOUD
region = sa-east-1
output = json
```

### Validacao (sts get-caller-identity)

| Perfil | Account retornado | Status |
|---|---|---|
| zapay-audit | 242201304053 | OK |
| zapay-log-archive | 183295435188 | OK |
| zapay-payer | 575108926897 | OK |
| zapay-olho-no-carro | 865350113542 | OK |
| zapay-prod | 717354774649 | OK |

### Contas SEM acesso no perimetro Zapay

Nenhuma — todas as 5 contas novas tinham `BR_PSAWSZPY_CLOUD` disponivel via SSO.

### Contas fora do perimetro (excluidas propositalmente)

| Conta | ID | Motivo |
|---|---|---|
| Tools | 148761638451 | Corpay/SemParar — fora do perimetro |
| Monitoring | 976193234625 | Corpay/SemParar — fora do perimetro |
| Payment | 831926599670 | Corpay/SemParar — fora do perimetro |
| Backup | 009160070721 | Corpay/SemParar — fora do perimetro |
| Sem Parar Doc IA DEV | 538311878212 | Corpay/SemParar — fora do perimetro |
| Sem Parar Doc IA QA | 487442499837 | Corpay/SemParar — fora do perimetro |
| Sem Parar Doc IA PROD | 110661053019 | Corpay/SemParar — fora do perimetro |

Nota: Tecnicamente o token SSO Zapay DA acesso a Tools (148761638451) e Monitoring (976193234625) — mas sao contas Corpay, nao foram provisionadas por instrucao.

## Comandos relevantes

```bash
# Listar todas as contas acessiveis via SSO Zapay
TOKEN=$(cat ~/.aws/sso/cache/d9024e47d7c449a9b378f92f2122607c6dfb7e99.json | python3 -c "import sys,json; print(json.load(sys.stdin)['accessToken'])")
aws sso list-accounts --access-token "$TOKEN" --region sa-east-1

# Roles disponiveis em uma conta
aws sso list-account-roles --account-id <ACCOUNT_ID> --access-token "$TOKEN" --region sa-east-1

# Validar perfil
aws sts get-caller-identity --profile zapay-prod

# Inventario rapido de EKS em qualquer conta
aws eks list-clusters --region sa-east-1 --profile <perfil>
```

## Licoes aprendidas

1. O nome "zapay-production" no Organizations NAO significa que e a conta de producao real. O workload real vive na conta chamada "Zapay" (071032557399). Nomes de conta no Organizations podem enganar — sempre validar com inventario de recursos.

2. A conta zapay-production (717354774649) tem apenas VPC `10.100.0.0/16` e bucket de Terraform state, sugerindo que e uma conta preparada para futura migracao de workloads (landing zone pattern). Acompanhar se recursos comecam a aparecer la.

3. O token SSO da sessao `zapay` (arquivo `d9024e47d7c449a9b378f92f2122607c6dfb7e99.json`) expira aproximadamente 1h apos o login. O `clientSecret` (registro do cliente OIDC) expira em ~90 dias. Um `aws sso login --profile zapay` renova a sessao de todas as contas simultaneamente.

4. A sessao SSO Zapay (`d-946773ab8e`) da acesso a contas Corpay/SemParar (Tools, Monitoring) — o controle de perimetro e por convencao/politica, nao por restricao tecnica do SSO. Cuidado redobrado ao usar o token raw via `list-accounts`.

## Referencias

- AWS SSO CLI profile config: https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html
- AWS Organizations: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts.html
- SSO cache token location: `~/.aws/sso/cache/*.json`
