---
tags: [task, azure, infra, postgresql, ai-agents, database]
status: em andamento
criado: 2026-05-12
---

# TASK1247886 — Criação de Azure Database for PostgreSQL (AI Agents App)

---

## 📋 Descrição Original

> Para a internalização e continuidade da iniciativa de IA no APP, precisamos da criação de recursos Azure Database for PostgreSQL.
> 
> 1. Abaixo seguem os recursos que precisamos na subscription DIGITAL-NPROD https://portal.azure.com/#resource/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021
>    1.1. No grupo de recursos `stp-dig-rg-aiagentsapp-nprd`, precisamos criar o recurso PostgreSQL com sugestão de nomenclatura `stp-dig-pg-aiagentsapp-nprd`
>    1.2. No grupo de recursos `stp-dig-rg-aiagentsapp-hml-nprd`, precisamos criar o recurso PostgreSQL com sugestão de nomenclatura `stp-dig-pg-aiagentsapp-hml-nprd`
> 
> 2. Abaixo seguem os recurso que precisamos na subscription DIGITAL-PROD https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/overview
>    2.1. No grupo de recursos `stp-dig-rg-aiagentsapp-prd`, precisamos criar o recurso PostgreSQL com sugestão de nomenclatura `stp-dig-pg-aiagentsapp-prd`
> 
> Para todos os recursos, a sugestão de provisionamento é Flexible Server Deployment, Burstable Tier, 1 B1MS (1 vCore) x 730 Hours, Storage - Premium SSD, 29 GiB Storage, 0 GiB Additional Backup storage - LRS redundancy
> 
> Qualquer dúvida, podem chamar a equipe de desenvolvimento (João Barth e/ou Luiz Vinholi)

---

## 🧠 Briefing da Tarefa

**O que precisa ser feito:** Criar 3 instâncias de Azure Database for PostgreSQL — Flexible Server, uma para cada ambiente (NPRD, HML, PRD), dentro dos Resource Groups do projeto AI Agents App.

**Onde vou atuar:** Portal Azure → Subscriptions DIGITAL-NPROD e DIGITAL-PROD → Resource Groups do projeto `aiagentsapp` → serviço Azure Database for PostgreSQL.

**Principal cuidado:** A especificação de sizing é idêntica para os 3 ambientes (Burstable B1MS, 29 GiB Premium SSD, LRS). Não confundir com tiers maiores. E os nomes dos servidores seguem o padrão de nomenclatura da empresa — validar antes de confirmar a criação.

**Como validar no final:** Confirmar que os 3 recursos PostgreSQL aparecem nos respectivos RGs com status "Available", tier correto (B1MS) e storage configurado (29 GiB, Premium SSD, LRS).

---

## 🔗 Associação com Tasks Anteriores

| Task relacionada | Relação |
|---|---|
| [[TASK1247602]] | **Mesmo projeto, mesmo padrão.** Lá você criou Web App + Container Registry nos mesmos 3 RGs (`nprd`, `hml-nprd`, `prd`) para o AI Agents Dashboard. Aqui você repete a lógica: mesmo projeto, mesmos ambientes, mesmo raciocínio de "1 recurso por RG, 3 ambientes". A diferença é o tipo de recurso (PostgreSQL ao invés de Web App + ACR). |
| [[CHG0094480]] | **Mesmo produto (IA no APP).** Essa change envolve o setup completo de produção do AI Agents App — modelos OpenAI, CosmosDB, variáveis de ambiente, APIM. A TASK1247886 é mais uma peça do mesmo quebra-cabeça: o PostgreSQL que a aplicação vai usar. |

> 💡 Não encontrei tasks anteriores que envolvessem especificamente a criação de PostgreSQL Flexible Server, então este é um tipo novo de recurso para você.

---

## 🧠 Ancoragem Mental

> Pense assim: você já fez o mesmo "gesto" na [[TASK1247602]] — **provisionar recurso X nos 3 ambientes do AI Agents App**. Lá era Web App + ACR, aqui é PostgreSQL. O padrão é idêntico:
> 
> **3 ambientes → 3 RGs → 3 recursos com nomes padronizados → mesma config.**
> 
> A única diferença é o "tipo de peça" que você está encaixando.

---

## 📦 Recursos Identificados

| Ambiente | Subscription | Resource Group | Nome do PostgreSQL | Tier |
|---|---|---|---|---|
| NPRD | DIGITAL-NPROD | `stp-dig-rg-aiagentsapp-nprd` | `stp-dig-pg-aiagentsapp-nprd` | B1MS |
| HML | DIGITAL-NPROD | `stp-dig-rg-aiagentsapp-hml-nprd` | `stp-dig-pg-aiagentsapp-hml-nprd` | B1MS |
| PRD | DIGITAL-PROD | `stp-dig-rg-aiagentsapp-prd` | `stp-dig-pg-aiagentsapp-prd` | B1MS |

**Spec comum a todos:**
- Deployment: **Flexible Server**
- Compute Tier: **Burstable**
- SKU: **B1MS** (1 vCore)
- Storage: **Premium SSD, 29 GiB**
- Backup: **0 GiB adicional, LRS redundancy**

---

## ✅ Checklist de Execução

- [ ] Acessar subscription **DIGITAL-NPROD**
  - [ ] Ir ao RG `stp-dig-rg-aiagentsapp-nprd` → Criar PostgreSQL `stp-dig-pg-aiagentsapp-nprd`
  - [ ] Ir ao RG `stp-dig-rg-aiagentsapp-hml-nprd` → Criar PostgreSQL `stp-dig-pg-aiagentsapp-hml-nprd`
- [ ] Acessar subscription **DIGITAL-PROD**
  - [ ] Ir ao RG `stp-dig-rg-aiagentsapp-prd` → Criar PostgreSQL `stp-dig-pg-aiagentsapp-prd`
- [ ] Configurar os 3 com: Flexible Server, Burstable B1MS, 29 GiB Premium SSD, LRS
- [ ] Definir credenciais de admin (usuário/senha) — anotar em local seguro
- [ ] Compartilhar credenciais com a equipe de dev se necessário

---

## ✅ Checklist de Validação

- [ ] Os 3 servidores PostgreSQL aparecem nos respectivos RGs?
- [ ] Status de todos é **"Available"**?
- [ ] Tier está como **Burstable B1MS** (não General Purpose ou Memory Optimized)?
- [ ] Storage está como **29 GiB Premium SSD com LRS**?
- [ ] Os nomes seguem exatamente a nomenclatura sugerida?
- [ ] Backup storage está como **0 GiB adicional**?

---

## ⚠️ Pontos de Atenção / Dúvidas

- O chamado usa "sugestão de nomenclatura" — pode haver padrão corporativo que exija ajuste. Confirmar se os nomes propostos estão de acordo.
- Credenciais de admin do PostgreSQL: o chamado não especifica usuário/senha. Definir e documentar de forma segura.
- Networking: o chamado não menciona se o acesso deve ser público ou privado (VNet integration). Na [[TASK1247602]], o acesso era via VPN. Vale confirmar se o PostgreSQL também deve ser privado.
- Em caso de dúvida, o chamado aponta contatos diretos: **João Barth** e/ou **Luiz Vinholi**.

---

## 🔧 Execução / Evidências

> *Documente aqui cada passo executado: prints, configs aplicadas, IDs de recursos criados.*

---

## 📝 Anotações Pessoais

> Para começar o trabalho eu copiei o conteúdo para azure postgresql flexible server dentro do Registry do Terraform: [azurerm_postgresql_flexible_server | Resources | hashicorp/azurerm | Terraform | Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server)

Eu escolhi o ambiente de nprd para começar, o RG é o 
Criei um postgresql.tf dentro da pasta do RG que devo

---
