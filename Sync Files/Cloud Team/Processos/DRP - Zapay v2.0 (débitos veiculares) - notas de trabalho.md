---
tags: [trabalho, sem-parar, zapay, drp, aws, oci, débitos-veiculares]
data: 2026-07-27
---

# DRP Zapay v2.0 (débitos veiculares) — notas de trabalho

> [!info] Sobre este documento
> Referência: `PR_DRP_001_B2C - Plano de Recuperação de Desastres SEM PARAR DOC 20260702 v2.0 1.pdf`, recebido do Tibúrcio em 2026-07-27. É o DRP oficial (v2.0, emitido julho/2026, 13 páginas) da unidade Sem Parar Doc (Zapay, Gringo, ONC), com foco atual no processo-core de **débitos veiculares (Zapay)**.
>
> Ver também: [[DRP - Metodologia BIA-PCN-DRP (SPDOCS)]]

---

## 🎯 Gap identificado — Seção 6 (visão geral dos ambientes computacionais)

A seção 6 atual do documento (pág. 8) descreve um ambiente **genérico on-premises**, aparentemente herdado de outro processo:

- Produção: DC1 (Osasco/SP) e DC2 (Vinhedo/SP) — datacenters Ascenty
- Contingência: VMs (VMWare) em nuvem, OCI **ou** AWS
- Servidores: Dell PowerEdge + VMWare ESXi 8.0.3, cluster OpenShift
- Banco de dados: Oracle Exadata X11 on-premises (19c) — bancos **CGMP6 (Orbill)**, **CGMP17 (Matera)**, **CGMP4 (Protheus)**; réplica em Dell PowerFlex + Oracle Active Dataguard, também no OCI

Isso **não bate** com os sistemas que a própria seção 6.2 do documento lista como responsáveis pelo processo de débitos veiculares:

- Plataforma **Zapay** (Front-End, Back-End, APIs ZAPI)
- **Warden** (CRM)
- Integrações **DETRAN/SENATRAN**
- Antifraude **CyberSource**
- **Debts-Service**, **Observer**, **Zagueiro**

Esses sistemas do Zapay provavelmente rodam em **AWS**, não no Exadata/DC1-DC2 descrito (que parece ser o ambiente do "B2C Core Process"/Orbill, um processo mais amplo e talvez diferente). **É essa a lacuna que o Tibúrcio pediu para o Felipe preencher**: descrever o ambiente real (contas AWS, VPCs, topologia, banco de dados, forma de acesso) desses sistemas especificamente.

> [!tip] Como preencher
> O agente `aws-zapay-architect` tem acesso de leitura às contas AWS do Zapay (prod `071032557399` / staging `901943060028`) e pode levantar topologia real, EKS, redes e IAM para escrever essa seção com precisão, cruzando com o Terraform declarado.

---

## 📋 Sistemas críticos (débitos veiculares) — conforme documento

| Item | Detalhe |
|---|---|
| **Usuário responsável do processo** | Amanda Botelho |
| **RTO declarado no documento** | ≤ 8 horas |
| **RTO-alvo mencionado pelo Tibúrcio (reunião 2026-07-22)** | < 4 horas — indica que o RTO do documento está desatualizado/conservador e deveria ser revisado nesta instância |
| **Justificativa (do doc)** | Indisponibilidade impede consulta a órgãos públicos/bancários, compromete o core da operação, gera perda de leads/conversões |
| **Data do último teste (campo do doc)** | "a agendar" — mas o cronograma na pág. 9 já mostra um teste de DR **realizado em 2026-03-27**. Inconsistência dentro do próprio documento a esclarecer. |

---

## ✅ Teste de DR já realizado (2026-03-27) — resultados reais

Conduzido por Tibúrcio, ciclo completo desde kick-off (05/jan) até encerramento (31/mar/2026). Ambiente de DR usado foi **OCI** (não AWS) — pods via Bastion/K9S, sync via Velero, banco via Oracle Active Dataguard. Parece ser o teste do processo **Orbill/CGMP**, não necessariamente o mesmo escopo AWS do Zapay/ZAPI — vale confirmar com o Tibúrcio se são o mesmo processo ou dois processos distintos dentro do "core".

Tempos medidos:

| Fase | RTO medido |
|---|---|
| Atividades de infraestrutura (subir Orbill, converter banco DR p/ Read-Write, ativar pods) | **0:42** |
| Validação de sistemas (análise de transação GTO+VPE, EDI, tarifação) | **2:18** |
| Retorno à normalidade (desligar ambiente DR, reverter banco p/ Read-Only) | **0:11** |

POPs usados: `POP_INFR_DR_OCI_001` (Deployments_OKE), `002` (Failover_NFS), `003` (Sync_Deployments), `004` (Bastion), `005` (ORBILL-START), `POP_INFR_DBA_109` (Dataguard — Operações).

---

## 🔑 Pessoas citadas no documento

| Nome | Papel |
|---|---|
| Tiburcio R. Santos Junior | Recovery Team Leader, aprovador v2.0 |
| Guilherme La Torraca | Aprovador v2.0; definição da solução DR (cloud) |
| Marcos Junior | Definição de escopo |
| Esau | Topologia Prod x DR; revisão da planilha passo-a-passo |
| Leo Bastos | Validação do ambiente de produção (infra); ativação de pods |
| Diogo | Redes (produção e contingência) |
| Enio | Regras de firewall/conexões |
| Silvano / Indiara | Cenários de teste; análise de transação |
| Wellington | Levantamento de custos do teste (cloud) |
| Marcelo / Jeison | Banco de dados (Dataguard) |
| Luciano Balabem | Infra/Server — ligar/desligar máquinas Orbill |
| Fabiana Lourenço | CPqD — start/stop da aplicação Orbill |
| Amanda Botelho | Usuário responsável pelo processo de débitos veiculares |

---

## 📌 Próximos passos (Felipe)

1. Escrever a seção 6 do DRP especificamente para o ambiente **AWS do Zapay** (contas, VPCs, topologia, banco de dados, forma de acesso) — usar o agente `aws-zapay-architect` para levantar dados reais.
2. Confirmar com Tibúrcio se o teste de DR de 2026-03-27 (ambiente OCI/Orbill) é o mesmo processo de "débitos veiculares" ou um processo core diferente — os sistemas não batem com a lista Zapay/ZAPI da seção 6.2.
3. Alinhar se o RTO declarado (8h) deve ser atualizado para refletir o alvo real (<4h) discutido em reunião.
