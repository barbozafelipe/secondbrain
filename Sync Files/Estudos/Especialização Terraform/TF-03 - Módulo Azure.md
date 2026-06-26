---
tags: [estudo, terraform, iac, pdi, azure]
updated: 2026-05-06
---

# TF-03 — Módulo Terraform para Azure

**Etapa 3 de 4** | Parte de: [[Especialização Terraform]]

---

## 🔔 Lembrete 3 — Criar módulo funcional para provisionamento Azure

**Data:** 09/10/2026 (Sex) · 16h | ⏱️ Tempo estimado: 60–90 min

> [!info] Primeiro passo (2 min)
> Abra o repositório de infra e crie a pasta `modules/azure/`. Se o módulo OCI da etapa anterior ficou bom, use a mesma estrutura como referência — você já sabe o padrão.

> [!note] Contexto
> Azure é sua segunda responsabilidade principal no cliente. Diferente do OCI, o provider AzureRM tem muito mais recursos documentados e exemplos da comunidade. O esforço aqui deve ser menor do que o OCI.

> [!success] Entregável desta etapa
> Um módulo Terraform para Azure com pelo menos 1 recurso funcional, revisado por par, usado em lab ou prod. Documentado no secondbrain.

---

## ✅ Checklist de Desenvolvimento

### Configuração do Provider AzureRM

- [ ] Autenticação: `az login` + service principal ou managed identity
- [ ] Configurar `provider "azurerm"` com `features {}` em `versions.tf`
- [ ] Testar: `terraform init` + `terraform plan` simples

### Estrutura do módulo

- [ ] Criar estrutura base:
  - `modules/azure/main.tf`
  - `modules/azure/variables.tf`
  - `modules/azure/outputs.tf`
  - `modules/azure/versions.tf`
  - `modules/azure/README.md`
- [ ] Definir variáveis com descrição e tipo (resource_group_name, location, etc.)
- [ ] Expor outputs relevantes (IDs dos recursos criados)

### Recursos a implementar *(adaptar ao que faz sentido no seu contexto)*

- [ ] **Resource Group** — agrupamento de recursos
- [ ] **Virtual Network** + subnets
- [ ] **Network Security Group (NSG)** com regras básicas
- [ ] *(Opcional)* Storage Account

### Validação e revisão

- [ ] `terraform validate` sem erros
- [ ] `terraform plan` cria os recursos esperados em subscription de lab
- [ ] Pedir revisão do módulo (Thiago ou Wellington)
- [ ] Aplicar em lab (`terraform apply`) e confirmar funcionamento

### Documentação

- [ ] Preencher `README.md` com: o que faz, inputs, outputs, exemplo de uso
- [ ] Registrar diferenças relevantes entre o módulo OCI e Azure nas anotações abaixo

---

## 📝 Anotações e Decisões de Design

*(Use este espaço durante o desenvolvimento)*

---

## 🔗 Links desta etapa

- [Provider AzureRM — Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [AzureRM — Autenticação com Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
- [Terraform + Azure — Tutorial oficial HashiCorp](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)
- [terraform-azurerm-modules (referência)](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale)
