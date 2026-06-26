---
tags: [estudo, terraform, iac, pdi, oci, oracle]
updated: 2026-05-06
---

# TF-02 — Módulo Terraform para OCI

**Etapa 2 de 4** | Parte de: [[Especialização Terraform]]

---

## 🔔 Lembrete 2 — Criar módulo funcional para provisionamento OCI

**Data:** 11/09/2026 (Sex) · 16h | ⏱️ Tempo estimado: 60–90 min

> [!info] Primeiro passo (2 min)
> Abra o repositório onde você vai criar o módulo (ou crie uma pasta `modules/oci/` no repositório de infra do time). Criar a estrutura de pastas já é o primeiro commit — e é o suficiente para começar.

> [!note] Contexto
> Você já conhece OCI do trabalho — é sua responsabilidade principal no cliente. A ideia aqui não é aprender OCI do zero, mas **formalizar em Terraform o que você já faz manualmente ou via console**. Comece pelo recurso que você mais provisiona.

> [!success] Entregável desta etapa
> Um módulo Terraform para OCI com pelo menos 1 recurso funcional, revisado por um colega (Thiago ou Wellington), usado em lab ou prod. Documentado no secondbrain.

---

## ✅ Checklist de Desenvolvimento

### Configuração do Provider OCI

- [ ] Configurar autenticação do provider OCI (`~/.oci/config` ou variáveis de ambiente)
- [ ] Testar conexão: `terraform init` + `terraform plan` em um recurso simples
- [ ] Definir versão do provider em `versions.tf`

### Estrutura do módulo

- [ ] Criar estrutura base:
  - `modules/oci/main.tf`
  - `modules/oci/variables.tf`
  - `modules/oci/outputs.tf`
  - `modules/oci/versions.tf`
  - `modules/oci/README.md`
- [ ] Definir variáveis com descrição e tipo (compartment_id, region, etc.)
- [ ] Expor outputs relevantes (OCID dos recursos criados)

### Recursos a implementar *(adaptar ao que faz sentido no seu contexto)*

- [ ] **Compartment** — agrupamento lógico de recursos
- [ ] **VCN (Virtual Cloud Network)** + subnets pública e privada
- [ ] **Security Lists** ou **NSGs** com regras básicas
- [ ] *(Opcional)* Internet Gateway + Route Table

### Validação e revisão

- [ ] `terraform validate` sem erros
- [ ] `terraform plan` cria os recursos esperados em conta de lab
- [ ] Pedir revisão do módulo ao **Thiago** (referência técnica em OCI no time)
- [ ] Aplicar em lab (`terraform apply`) e confirmar funcionamento

### Documentação

- [ ] Preencher `README.md` do módulo com: o que faz, inputs, outputs, exemplo de uso
- [ ] Registrar aprendizados e decisões de design na seção de anotações abaixo

---

## 📝 Anotações e Decisões de Design

*(Use este espaço durante o desenvolvimento — registre o que funcionou, o que não funcionou e por quê)*

---

## 🔗 Links desta etapa

- [Provider OCI — Terraform Registry](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Provider — Autenticação](https://registry.terraform.io/providers/oracle/oci/latest/docs#authentication)
- [OCI Terraform Examples (GitHub oficial)](https://github.com/oracle/terraform-provider-oci/tree/master/examples)
- [HashiCorp — Criando módulos](https://developer.hashicorp.com/terraform/tutorials/modules/module-create)
