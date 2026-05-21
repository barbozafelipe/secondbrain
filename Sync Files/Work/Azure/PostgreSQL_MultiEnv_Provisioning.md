---
aliases: [PostgreSQL Multi-Environment, Azure PostgreSQL, Subnet Delegation PostgreSQL]
tags: [azure, postgresql, terraform, iac, arquitetura]
---

# PostgreSQL Flexible Server - Padrão Multi-Ambiente

Este documento registra o padrão arquitetural e de provisionamento estabelecido para servidores **Azure Database for PostgreSQL Flexible Server** nos ambientes NPROD, HML e PRD (Ex: Projeto AI Agents App).

## 1. Topologia de Rede e Subnets

Para garantir que os servidores PostgreSQL sejam acessíveis apenas de forma privada, utilizamos o padrão de **VNet Integration** com **Subnet Delegation**.

- **NPROD e HML** compartilham a mesma Virtual Network (`stp-dig-vnet-nprd`). Portanto, a **mesma** subnet delegada (`stp-dig-snet-psql-nprd`) é utilizada em ambos os ambientes.
- **PRD** possui sua própria VNet e Subnet delegada (`stp-dig-snet-psql-prd`).

### Requisitos da Subnet:
Para o Terraform conseguir atrelar o PostgreSQL na subnet, ela obrigatoriamente deve conter o seguinte bloco de `delegation` no `main.tf` ou `terraform.tfvars` do repositório base de redes:

```hcl
delegation = [{
  name = "Microsoft.DBforPostgreSQL.flexibleServers"
  service_delegation = [{
	actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
	name    = "Microsoft.DBforPostgreSQL/flexibleServers"
  }]
}]
```
> **Nota de Manutenção:** Ao criar novas subnets delegadas, lembre-se sempre de atrelar a Route Table correspondente (`azurerm_subnet_route_table_association`) do ambiente para evitar roteamento assíncrono ou perda de conectividade.

## 2. Resolução de Nomes (Private DNS Zone)

Para evitar conflitos de FQDN (Fully Qualified Domain Name) entre ambientes que compartilham a mesma assinatura/rede, cada ambiente deve provisionar a sua própria **Private DNS Zone**.

O sufixo padrão obrigatório da Azure para PostgreSQL Flexible Server é `.postgres.database.azure.com`.
Para evitar colisão, inserimos o nome do ambiente dentro do nome da zona:
- **NPROD:** `stp-dig-aiagentsapp-nprd.postgres.database.azure.com`
- **HML:** `stp-dig-aiagentsapp-hml-nprd.postgres.database.azure.com`
- **PRD:** `stp-dig-aiagentsapp-prd.postgres.database.azure.com`

No `postgresql.tf`, referenciamos o `.private_dns_id` dessa zona gerada e configuramos `public_network_access_enabled = false`.

## 3. TroubleShooting Frequentes no Terraform

### State Blob Locked
Se um provisionamento de banco (que pode demorar até 15 minutos) for interrompido abruptamente (`Ctrl+C` / Pipeline Cancelada), o `.tfstate` na Azure ficará travado aguardando o lock.
**Solução:** Rodar `terraform force-unlock <LOCK_ID>`.

### Error: Unreadable module directory
Caminhos relativos em módulos base antigos (como `../../MODULES/vnet`) costumam quebrar se o repositório crescer ou for reorganizado.
**Solução:** Sempre conte a árvore de diretórios do local do `main.tf` até a pasta raiz e adicione os `../` necessários. Ex: `../../../MODULES/vnet`.

### Error: no available releases match the given constraints
Conflito quando a máquina/state tem `~> 4.0` mas o código antigo pede `~> 3.0`.
**Solução:** Alterar o `provider.tf` / `terraform.tf` e `versions.tf` para usar restrições abertas como `>= 3.0`.

## 4. Extensões PostgreSQL no Azure (Allowlist)

No Azure PostgreSQL Flexible Server, extensões não são habilitadas por padrão. Antes de rodar `CREATE EXTENSION` no banco, é obrigatório adicionar a extensão na **allowlist** do servidor via Server Parameter `azure.extensions`.

> **Atenção:** Sem esse passo, o `CREATE EXTENSION` vai falhar com um erro de permissão mesmo que o usuário seja admin.

### Via Terraform (recomendado)

```hcl
resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.NOME_DO_SERVIDOR.id
  value     = "VECTOR"  # separar múltiplas extensões por vírgula: "VECTOR,UUID-OSSP,CITEXT"
}
```

Depois do `terraform apply`, rodar dentro do banco desejado:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### Via Portal do Azure (manual)

1. Vá em **Azure Database for PostgreSQL** → Servidor → **Settings → Server parameters**.
2. Busque por `azure.extensions`.
3. Marque `VECTOR` (e quaisquer outras necessárias) na lista.
4. Clique em **Save** — não exige restart do servidor.

### Extensões comuns para projetos de AI/Embeddings

| Extensão | Uso | Nome no azure.extensions |
|---|---|---|
| pgvector | Busca por similaridade / embeddings | `VECTOR` |
| uuid-ossp | Geração de UUIDs | `UUID-OSSP` |
| pg_trgm | Busca por similaridade textual | `PG_TRGM` |
| citext | Texto case-insensitive | `CITEXT` |
