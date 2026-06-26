---
tags: [estudo, terraform, iac, pdi, cicd, github-actions, documentação]
updated: 2026-05-06
---

# TF-04 — CI/CD com Terraform + Documentação de Patterns

**Etapa 4 de 4** | Parte de: [[Especialização Terraform]]

---

## 🔔 Lembrete 4 — Implementar CI/CD com Terraform + Documentar 2 patterns

**Data:** 29/10/2026 (Qui) · 14h | ⏱️ Tempo estimado: 90 min

> [!info] Primeiro passo (2 min)
> Abra o repositório de infra onde os módulos OCI e Azure estão. Crie o arquivo `.github/workflows/terraform.yml`. Se o repositório ainda não tiver GitHub Actions configurado, esse é o seu ponto de partida.

> [!note] Contexto
> Esta é a etapa final e também a mais visível — o pipeline vai automatizar o que hoje é feito manualmente. É o tipo de coisa que o Wellington e o Guilherme veem rodar. Faça funcionar antes de polir.

> [!success] Entregável desta etapa — Critério do PDI
> - Pipeline CI/CD com Terraform rodando (pelo menos `plan` automático em PRs)
> - 2 patterns documentados em `infra/runbooks/`
> - PDI completo: 100% das etapas entregues

---

## ✅ Checklist de Desenvolvimento

### CI/CD com GitHub Actions

- [ ] Criar `.github/workflows/terraform.yml`
- [ ] Configurar trigger em `pull_request` (roda `terraform plan`)
- [ ] Configurar trigger em `push main` (roda `terraform apply`)
- [ ] Configurar secrets no repositório: credenciais AWS / Azure / OCI
- [ ] Testar: abrir um PR simples e confirmar que o `plan` roda no CI
- [ ] Testar: merge na main e confirmar que o `apply` executa
- [ ] Adicionar comentário automático no PR com output do `terraform plan` *(opcional mas valioso)*

### Documentação dos 2 Patterns em `infra/runbooks/`

- [ ] **Pattern 1** — Módulo OCI: como usar, variáveis obrigatórias, exemplo completo
  - Arquivo: `infra/runbooks/terraform-modulo-oci.md`
- [ ] **Pattern 2** — Módulo Azure: como usar, variáveis obrigatórias, exemplo completo
  - Arquivo: `infra/runbooks/terraform-modulo-azure.md`
- [ ] Cada runbook deve ter: título, propósito, pré-requisitos, exemplo de código, outputs esperados
- [ ] Pedir revisão de pelo menos 1 pessoa do time antes de considerar entregue

### Revisão final do PDI

- [ ] Confirmar que os 2 módulos (OCI + Azure) estão em uso ou testados em lab
- [ ] Confirmar que os 2 runbooks estão escritos e revisados
- [ ] Confirmar que o pipeline CI/CD está funcional
- [ ] Registrar conclusão no Qulture.Rocks (PDI) — a plataforma atualiza o progresso automaticamente

---

## 📝 Template de Runbook

*Use como base para cada pattern que documentar:*

```markdown
# Runbook: [Nome do módulo]

## Propósito
O que este módulo faz e quando usar.

## Pré-requisitos
- Terraform >= X.X
- Provider configurado (link para autenticação)
- Acesso ao ambiente (lab / prod)

## Como usar

\`\`\`hcl
module "nome" {
  source = "./modules/oci"  # ou azure

  variavel_obrigatoria = "valor"
  variavel_opcional    = "valor"
}
\`\`\`

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| variavel_obrigatoria | string | ✅ | Descrição |

## Outputs

| Nome | Descrição |
|---|---|
| output_id | ID do recurso criado |

## Troubleshooting comum
- Erro X → causa e solução
```

---

## 🔗 Links desta etapa

- [GitHub Actions — Terraform workflow oficial HashiCorp](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)
- [terraform-github-actions (marketplace)](https://github.com/marketplace/actions/hashicorp-setup-terraform)
- [Exemplo de workflow com plan comment em PR](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions#review-actions-workflow)
