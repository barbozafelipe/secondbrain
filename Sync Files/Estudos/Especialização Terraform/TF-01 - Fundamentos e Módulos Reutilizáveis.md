---
tags: [estudo, terraform, iac, pdi, fundamentos, módulos]
updated: 2026-05-06
---

# TF-01 — Fundamentos e Módulos Reutilizáveis

**Etapa 1 de 4** | Parte de: [[Especialização Terraform]]

---

## 🔔 Lembrete 1 — Estudar fundamentos Terraform + módulos reutilizáveis

**Data:** 14/08/2026 (Sex) · 16h | ⏱️ Tempo estimado: 60–90 min

> [!info] Primeiro passo (2 min)
> Acesse [developer.hashicorp.com/terraform/tutorials](https://developer.hashicorp.com/terraform/tutorials) e abra o tutorial **"Get Started"** (qualquer provider). Não precisa terminar hoje — só começar já é o suficiente para ativar o modo de aprendizado.

> [!note] Contexto
> Você acabou de passar na certificação AWS (ou está muito perto). Terraform é a próxima fronteira. Muito do que você já usa no trabalho (provisionamento de infra, variáveis, backends) vai soar familiar — você só vai aprender o vocabulário formal.

> [!success] Ao terminar esta etapa
> Você terá a base para construir os módulos reais nas etapas 2 e 3. Sem essa base, os módulos ficam frágeis. Com ela, ficam reutilizáveis de verdade.

---

## ✅ Checklist de Estudo

### Fundamentos HCL e Workflow

- [ ] **Blocos básicos**: `resource`, `variable`, `output`, `locals`, `data`
- [ ] **Tipos de variáveis**: string, number, bool, list, map, object
- [ ] **Workflow básico**: `terraform init` → `plan` → `apply` → `destroy`
- [ ] **Arquivo de estado (tfstate)**: o que é, por que não versionar, onde guardar

### State e Backend Remoto

- [ ] **State local vs remoto**: diferença e quando usar cada um
- [ ] **Backend S3 + DynamoDB locking** (padrão AWS): configurar em lab
- [ ] **`terraform state` commands**: `list`, `show`, `mv`, `rm`
- [ ] **Workspaces**: o que são e quando fazem sentido

### Providers

- [ ] **Provider AWS** — testar: criar bucket S3 e IAM user simples em conta de dev
- [ ] **Provider AzureRM** — testar: criar resource group e storage account em lab
- [ ] **Provider OCI** — instalar e autenticar: criar compartment de teste

### Módulos Reutilizáveis

- [ ] **Estrutura de módulo**: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`
- [ ] **Módulo local** (chamado de outro diretório do projeto)
- [ ] **Módulo do Registry**: chamar um módulo público (`terraform-aws-modules/vpc/aws`)
- [ ] **Passar variáveis para módulos** e usar os outputs
- [ ] **Boas práticas**: defaults, validações, descrições em cada variável

---

## 📝 Anotações de Estudo

*(Use este espaço durante a sessão)*

---

## 🔗 Links desta etapa

- [Terraform Tutorials — Get Started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
- [Terraform Registry — Módulos](https://registry.terraform.io/)
- [Módulos — Documentação oficial](https://developer.hashicorp.com/terraform/language/modules)
- [Backend S3 — Documentação](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
