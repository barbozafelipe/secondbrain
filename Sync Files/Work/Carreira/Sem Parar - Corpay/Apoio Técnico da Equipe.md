---
tags: [trabalho, sem-parar, equipe, apoio-tecnico, contexto]
criado: 2026-05-15
atualizado: 2026-05-15
---

# Contexto de Apoio Técnico da Equipe

> Esta nota é um repositório vivo para armazenar o contexto técnico de como cada membro da equipe (Thiago, Wellington, João, Lucas, etc.) me ajuda no dia a dia. 
> Sempre que houver uma interação técnica, dicas de código, padrões de infraestrutura ou prints de conversas, os aprendizados devem ser resumidos aqui para dar contexto à IA em futuras conversas.

---

## 🔹 Thiago (Kubernetes / IaC / Networking)
- **Como me orienta no dia a dia:**
  - **Terraform (Senhas/Secrets):** Pediu para sempre criar variáveis sensíveis (`sensitive = true`) no próprio arquivo `.tf` (ex: `postgresql.tf`) e referenciar a variável no resource, em vez de deixar a senha hardcoded. A senha deve ser passada via linha de comando no plan/apply (ex: `$env:TF_VAR_admin_password = "senha"`). Após o provisionamento, a senha gerada deve ser armazenada em local seguro e enviada para quem vai cuidar do recurso (equipe de dev ou DBA, ex: João Barth/Luiz Vinholi).
  - *(Adicione aqui os resumos de futuros prints e conversas com o Thiago)*

## 👑 Wellington (Tech Lead / Arquitetura)
- **Como me orienta no dia a dia:**
  - **Delegação:** Está me passando progressivamente tarefas de provisionamento (Azure, AWS) e configuração (Rancher). A expectativa é que eu monte a estrutura (ex: Terraform) de forma segura, valide via `plan` e não faça `apply` de cara sem alinhar.
  - *(Adicione aqui os resumos de futuros prints e conversas com o Wellington)*

## 🔹 João Pedro (GCP / FinOps)
- **Como me orienta no dia a dia:**
  - *(Adicione aqui os resumos de futuros prints e conversas com o João Pedro)*

## 🔹 Lucas (AWS / Argo / GitOps)
- **Como me orienta no dia a dia:**
  - *(Adicione aqui os resumos de futuros prints e conversas com o Lucas)*

---

## 🛠️ Padrões e Práticas da Squad
> Regras gerais que a equipe espera que eu siga nas minhas entregas:
- **Testes e Validação:** Nunca rodar `terraform apply` sem antes ter um `terraform plan` validado, especialmente em recursos que envolvem rede (VNets, DNS) e banco de dados.
- **Reaproveitamento:** Sempre verificar se já existem módulos (ex: `module.rg`) ou Data Sources (`data.azurerm_subnet`) antes de criar recursos do zero.
