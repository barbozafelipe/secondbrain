---
tags: [estudo, carreira, pdi, kubernetes, rancher, argocd, helm, rbac, gitops]
updated: 2026-05-05
---

# 🟡 Trilha 2 — Kubernetes + GitOps

**Prazo: Contínuo** · Parte de: [[Plano de Estudo — Sem Parar]]

> Wellington quer te envolver com ArgoCD junto com o Lucas. Você já tem a base de RBAC — expanda daqui.
> Recursos: [Kubernetes docs](https://kubernetes.io/docs) · [ArgoCD docs](https://argo-cd.readthedocs.io)

---

## ✅ 2A — Kubernetes core

- [ ] **RBAC** — RoleBinding, ClusterRoleBinding, ClusterRole, diferença de escopo
- [ ] **Workloads** — Deployment, Pod, ReplicaSet, rollout, rollback via `kubectl`
- [ ] **HPA** — Horizontal Pod Autoscaler, métricas custom (PromQL), CPU vs HTTP requests
- [ ] **Helm** — charts, values.yaml, templates, install/upgrade/rollback

---

## ✅ 2B — GitOps com ArgoCD

- [ ] **Conceitos GitOps** — sync, drift detection, reconciliation loop, GitOps vs push-based
- [ ] **ArgoCD — Applications** — Application manifest, source, destination, sync policies
- [ ] **ArgoCD — App of Apps** — pattern usado para multi-cluster/multi-app
- [ ] Pedir ao **Lucas** para mostrar um Application real no cluster deles
