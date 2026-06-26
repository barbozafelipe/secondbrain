---
tags: [trabalho, sem-parar, week-meeting, squad, kubernetes, rbac]
data: 2026-05-05
---

# Week Meeting — 05/05/2026

> [!info] Mapa rápido do contexto
> Reunião focada em **governança de permissões Kubernetes (RBAC)**. Contexto: Rancher como painel de gestão dos clusters, com grupos mapeados via Provider. Objetivo: mapear os grupos existentes, identificar lacunas e padronizar permissões via ClusterRoleBinding em todos os clusters.

---

## ⚡ TL;DR — o que mais importa desta reunião

1. **Grupos K8s existentes**: Arquitetura, Cloud, DevOps, NOC, Produção e SRE — falta criar o grupo **K8s Servidores**.
2. **ClusterRoleBindings**: cada cluster precisa ter as bindings corretas por grupo — hoje a cobertura está incompleta ou inconsistente.
3. **Roles órfãs**: foi identificada pelo menos uma ClusterRole sem nenhuma regra configurada — candidata a exclusão.
4. **Padrão de permissões**: grupo Produção tem `get/list/watch` de pods + permissão de `delete` — faz sentido e deve ser replicado.
5. **Felipe**: tarefa inicial é incluir o grupo Servidores e mapear as permissões existentes por grupo em todos os clusters, entendendo os objetos `RoleBinding` e `ClusterRoleBinding`.


> [!tip] Ação prática
> - Abrir chamado para criar o grupo `k8s-servidores` no Identity Provider
> - Entrar em cada cluster no Rancher → aba **RBAC** → ClusterRoleBindings → listar grupos e roles associadas
> - Para cada role não padrão encontrada, abrir a configuração e verificar se tem regras definidas — se não tiver, propor exclusão
> - Replicar a binding do grupo Produção (`get/list/watch/delete` em pods) nos clusters que ainda não têm
> - Dúvidas: acionar Thiago ou Wellington

---

## 🗂️ Projetos em andamento

### Governança RBAC — Kubernetes / Rancher

> Contexto: os clusters são gerenciados pelo Rancher. Grupos são definidos no **Identity Provider** (configurado no Rancher como "Provider") e aparecem automaticamente disponíveis para associação nos clusters.

**Grupos já existentes no Provider**:
- `k8s-arquitetura`
- `k8s-cloud`
- `k8s-devops`
- `k8s-noc`
- `k8s-producao`
- `k8s-sre`

**Grupo faltando**:
- `k8s-servidores` — precisa ser criado e depois associado aos clusters

---

### Mapeamento de Permissões por Grupo

**Situação identificada nos clusters analisados**:

| Grupo | Permissão atual | Observação |
|---|---|---|
| SRE | `node-view`, `monitor-view`, `cluster-view`, `cluster-owner` (a verificar) | `cluster-owner` pode ser excessivo — investigar |
| DevOps | `edit` | Verificar se faz sentido em todos os clusters |
| Produção | Custom role: `get/list/watch` em pods + `delete` em pods | Faz sentido — deve ser replicado |
| Servidores | — | Grupo ainda não existe |

> [!important] Clusters sem nenhuma binding de grupo
> Clusters como o RSF/Produção tinham apenas os próprios membros de infra — sem nenhum grupo mapeado. Esse é exatamente o tipo de lacuna que a tarefa visa corrigir.

---

### ClusterRoles Órfãs — Limpeza

Durante a análise, foi encontrada pelo menos uma **ClusterRole sem regras definidas** (configuração nula). Essas roles:
- Não concedem nenhuma permissão
- Poluem o ambiente
- Devem ser excluídas após confirmação

**Fluxo para verificar uma ClusterRole não padrão**:
1. Rancher → cluster → **Roles** (ou ClusterRoles)
2. Abrir a role suspeita
3. Se o campo de regras estiver vazio → candidata a exclusão

---

### Ideia: Global ClusterRoleBinding (descartada por ora)

A ideia de criar uma **binding global** que se aplicasse automaticamente a todos os clusters foi avaliada e descartada — o Rancher não suporta GlobalClusterRoleBinding para grupos externos no fluxo atual.

**Alternativa adotada**: aplicar o padrão **cluster a cluster**, garantindo que toda vez que um novo cluster for criado, as bindings sejam aplicadas como parte do processo de setup.

---

### Cluster VB — Referência de Boas Práticas

O cluster VB foi citado como exemplo mais maduro — já tem múltiplos usuários como membros. A partir dele, o objetivo é replicar o padrão:

1. Verificar ClusterRoleBindings existentes
2. Confirmar se todos os grupos necessários estão mapeados com as permissões corretas
3. Usar como template para os demais clusters

---

## 🔑 Decisões tomadas

| Decisão | Motivo |
|---|---|
| Criar grupo `k8s-servidores` no Provider | Time de Servidores precisa de acesso mapeado via grupo, não usuário individual |
| Padrão por cluster (não global binding) | Rancher não suporta global binding para grupos externos no fluxo atual |
| Roles órfãs sem regras: excluir | Não concedem nenhuma permissão e poluem o ambiente |
| Permissão Produção: `get/list/watch/delete` pods | Faz sentido operacionalmente — replicar nos demais clusters |

---

## 📌 Glossário técnico desta reunião

| Termo | O que é |
|---|---|
| **RoleBinding** | Objeto K8s que associa uma Role a um usuário/grupo dentro de um namespace específico |
| **ClusterRoleBinding** | Igual ao RoleBinding, mas com escopo de cluster inteiro |
| **ClusterRole** | Conjunto de permissões definidas a nível de cluster (não namespaced) |
| **Rancher** | Plataforma de gestão de clusters Kubernetes — usado como painel central |
| **Provider** | Identity Provider configurado no Rancher — onde os grupos são criados e mapeados |
| **RBAC** | Role-Based Access Control — modelo de controle de acesso baseado em funções |
| **cluster-owner** | Role padrão do Rancher com permissão total sobre o cluster |
