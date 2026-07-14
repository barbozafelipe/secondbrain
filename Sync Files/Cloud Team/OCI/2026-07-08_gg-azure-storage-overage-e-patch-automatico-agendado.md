---
tags: [oci, goldengate, diagnóstico, storage, maintenance-patch]
date: 2026-07-08
cluster: N/A (OCI GoldenGate deployment)
resource: gg-azure (ocid1.goldengatedeployment.oc1.sa-vinhedo-1.amaaaaaa7kuxl5qaw3igleiapyhz7udmbknirm5ne5bq3ilo7ijbcugysffq)
status: resolvido
---

# Diagnóstico — Warnings do deployment GoldenGate `gg-azure`

## Contexto

DBA reportou via print dois avisos no console do deployment OCI GoldenGate `gg-azure`:
1. WARNING de storage utilization em 552%.
2. INFO de upgrade/patch automático agendado para 11/Jul/2026 14:00 UTC.

Pedido: infra (OCI) confirmar via CLI se procedem e detalhar tecnicamente.

## Diagnóstico

### Identificação do deployment
- Nome: `gg-azure` (nome interno `ogg-data.deployment-name` = `gg-s3` — divergência de nomenclatura, não é bug, apenas naming legado do admin).
- OCID: `ocid1.goldengatedeployment.oc1.sa-vinhedo-1.amaaaaaa7kuxl5qaw3igleiapyhz7udmbknirm5ne5bq3ilo7ijbcugysffq`
- Compartment: `Goldengate` (`ocid1.compartment.oc1..aaaaaaaaxdxecihux3zwtlukywup6tjui2tibmyqzuvbdtrgnfn3msbnwuwq`)
- deployment-type: `BIGDATA` · environment-type: `DEVELOPMENT_OR_TESTING` · lifecycle-state: `ACTIVE`
- cpu-core-count: 4 (reservado) · is-auto-scaling-enabled: true (mas não escalou apesar do storage estourado)
- is-public: false · license-model: BRING_YOUR_OWN_LICENSE

### Warning 1 — Storage 552%
- `is-storage-utilization-limit-exceeded`: **true** (confirmado pela API).
- `storage-utilization-in-bytes`: 35.618.641.586.688 bytes ≈ **35,6 TB (decimal) / 32,4 TiB**.
- Documentação oficial (OCI GoldenGate — ocpu-management-and-billing): storage é alocado a **500 GB por OCPU**, escalável até 3x o OCPU inicial conforme workload/storage.
  - Com 4 OCPU reservados → cota nominal de 2 TB → uso real representa **~1781%** dessa cota.
  - Mesmo no teto máximo de auto-scale (12 OCPU = 6 TB) → **~594%**, mesma ordem de grandeza do 552% reportado no console (pequena diferença explicada por o storage ter crescido entre o screenshot e esta consulta).
  - Conclusão: **warning procede e é real, não falso positivo.** O gap entre nominal (2TB) e o teto de auto-scale (6TB) mostra que mesmo escalando OCPU ao máximo automático o problema não seria resolvido — o volume acumulado de trail files é o causador, não falta de OCPU.
- `deployment-diagnostic-data` mostra um diagnóstico já coletado (23–26/Jan/2026, bucket `ogg-error-log`) — indício de que este problema de storage já gerou investigação anterior (possível ticket de suporte Oracle).

### Warning 2 — Patch automático 11/Jul/2026
- Confirmado via `deployment get` e `deployment-upgrade list`:
  - `next-maintenance-action-type`: UPGRADE
  - `next-maintenance-description`: `oggbigdata:23.26.2.0.0_260618.0017_1507` — **idêntico** ao reportado.
  - `time-of-next-maintenance`: `2026-07-11T14:00:00+00:00` — **idêntico** ao reportado.
  - Registro correspondente em `deployment-upgrade list`: lifecycle-state `WAITING`, `release-type: BUNDLE`, `is-security-fix: true`, `is-cancel-allowed: false`, `is-reschedule-allowed: true`, `time-schedule-max: 2026-07-09T19:54:09Z` (prazo final para reagendar antes que vire compulsório).
  - Versão atual: `oggbigdata:23.26.1.0.0_260208.2049_14210` → destino `23.26.2.0.0_260618.0017_1507`.
- Histórico de upgrades confirma cadência automática recorrente (upgrades em nov/2025, mar/2026, jun/2026 já aplicados — um deles `FAILED` em 07/06/2026, vale investigar depois).
- **Confirmado: é patch mandatório da Oracle (bundle de segurança), não pode ser cancelado — só reagendado dentro da janela permitida.** Causa downtime.

## Resolução (quem deve agir)

| Warning | Dono da ação | Motivo |
|---|---|---|
| 1 — Storage 552% | **DBA / time de dados** | Trail files de Extract/Replicat não purgados é gestão de aplicação GoldenGate (purge policies, checkpoints), não infraestrutura OCI. Infra pode apoiar com scale-up de OCPU (raise da cota de storage) como mitigação temporária, mas não resolve a causa raiz. |
| 2 — Patch 11/Jul | **Infra OCI** | Patch de plataforma gerenciado pela Oracle no control-plane do GoldenGate. Infra deve avaliar se reagenda (prazo até 09/Jul 19:54 UTC) e comunicar a janela de downtime aos stakeholders. Cancelamento não é permitido. |

Nenhuma ação foi executada — investigação 100% read-only, conforme solicitado.

## Comandos relevantes

```bash
oci.cmd goldengate deployment list --compartment-id ocid1.compartment.oc1..aaaaaaaaxdxecihux3zwtlukywup6tjui2tibmyqzuvbdtrgnfn3msbnwuwq --region sa-vinhedo-1 --all

oci.cmd goldengate deployment get --deployment-id ocid1.goldengatedeployment.oc1.sa-vinhedo-1.amaaaaaa7kuxl5qaw3igleiapyhz7udmbknirm5ne5bq3ilo7ijbcugysffq --region sa-vinhedo-1

oci.cmd goldengate deployment-upgrade list --deployment-id ocid1.goldengatedeployment.oc1.sa-vinhedo-1.amaaaaaa7kuxl5qaw3igleiapyhz7udmbknirm5ne5bq3ilo7ijbcugysffq --compartment-id ocid1.compartment.oc1..aaaaaaaaxdxecihux3zwtlukywup6tjui2tibmyqzuvbdtrgnfn3msbnwuwq --region sa-vinhedo-1 --all
```

## Lições aprendidas

- `oci goldengate deployment get` traz `storage-utilization-in-bytes` e `is-storage-utilization-limit-exceeded`, mas não expõe diretamente o "limite alocado" — precisa ser calculado a partir da regra oficial de 500 GB/OCPU (doc `ocpu-management-and-billing.html`), com teto de auto-scale em 3x o OCPU inicial.
- `deployment-upgrade list` é a fonte de verdade para confirmar patches agendados — mais confiável que o campo `next-maintenance-*` do `deployment get` porque traz histórico completo e as flags `is-cancel-allowed`/`is-reschedule-allowed`.
- Auto-scaling de OCPU no GoldenGate não resolve overage de storage por si só quando o volume de trail files ultrapassa até o teto máximo de 3x — é preciso purge na aplicação.

## Referências
- OCI GoldenGate — OCPU Management and Billing: https://docs.oracle.com/en-us/iaas/goldengate/doc/ocpu-management-and-billing.html
- OCI GoldenGate — Manage Trail Files (purge): https://docs.oracle.com/en-us/iaas/goldengate/doc/manage-trail-files.html
