---
tags: [trabalho, sem-parar, equipe, squad, referência]
atualizado: 2026-06-23
---

# Equipe — Cloud & Infraestrutura

> Mapa de quem faz o quê no squad de infra/cloud da Sem Parar (Corpay).
> Fonte: reuniões semanais ([[07-04-2026]], [[14-04-2026]], [[28-04-2026]], [[05-05-2026]], [[12-05-2026]], [[19-05-2026]], [[26-05-2026]], [[02-06-2026]], [[16-06-2026]], [[23-06-2026]]).

---

## 👑 Wellington — Tech Lead / Coordenador

- **Papel:** lidera o squad. Define prioridades, arquitetura macro, decisões de custo e governança. Delega tarefas e faz os direcionamentos estratégicos.
- **Atua em:** todas as clouds (AWS, Azure, GCP, OCI), mas se envolve diretamente em problemas críticos, negociações com fornecedores e decisões arquiteturais.
- **Projetos recorrentes:** redução de custo GCP (Gringo), Rancher, governança de clusters, rotação de certificados, Elastic (migração para Rancher).
- **Frase que resume:** ele decide o que fazer, quem faz, e quando escalar. Não executa tudo, mas sabe de tudo.

---

## 🔹 João Pedro — GCP / FinOps

- **Papel:** braço direito de Wellington na operação GCP. Troubleshooting, otimização de custo e integrações (Okta, IAP).
- **Cloud principal:** GCP (conta Gringo).
- **Projetos recorrentes:** BigQuery (economia de ~R$ 50k), resize de instâncias (C2 → N2), Spot Instances, recall de Spots, Okta + domínio Corpay, IAP para substituir VPN, limpeza de conta Gringo DR.
- **Frase que resume:** quando tem problema no GCP, João Pedro resolve. Quando tem custo alto no GCP, João Pedro corta.

---

## 🔹 Thiago — Kubernetes / IaC / Networking

- **Papel:** executa infra pesada — Helm, Terraform, Ingress, HAProxy, ArgoCD, Backstage. Referência para cluster tools, GitOps e mudanças de rede.
- **Cloud principal:** AWS + Azure (Sem Parar), mas apoia GCP (Gringo) e Afinz/Carvalt.
- **Projetos recorrentes:** Backstage + Harbor + GitOps, VB (NGINX → HAProxy), Rancher (integração de clusters), cluster tools (Terraform + manifests), Afinz (arquitetura VPC + EKS), Elastic (migração OpenShift → Rancher), GKE Standard staging.
- **Frase que resume:** se envolve infraestrutura Kubernetes, IaC ou rede, passa pelo Thiago.

---

## 🔹 Leonardo (Léo) — Observabilidade / Monitoring

- **Papel:** foco em Dynatrace, integração de logs/métricas, análise de incidentes e HPA.
- **Cloud principal:** GCP (Gringo), mas apoia AWS (Zapay).
- **Projetos recorrentes:** Dynatrace na Gringo (GCP Monitor, logs, agente), HPA por HTTP requests (Prometheus + GKE), post-mortem de incidentes, arquitetura Afinz.
- **Frase que resume:** se precisa de visibilidade (logs, métricas, alertas, traces), Leonardo é o cara.

---

## 🔹 Mateus — AWS (Zapay / Olho no Carro)

- **Papel:** executa a operação da Zapay e Olho no Carro no dia a dia. Lida com migração de workloads, descoberta de ambientes legados e planejamento de migração para Kubernetes.
- **Cloud principal:** AWS (Zapay, Olho no Carro).
- **Projetos recorrentes:** Olho no Carro (migração ECS → EKS, descoberta de ambiente, staging), passagem de conhecimento para SRE, proposta de WAF para resolver problema de VPN dos devs.
- **Frase que resume:** Mateus é o ponto focal da Zapay/Olho no Carro. Conhece o ambiente e está desbravando o legado.

---

## 🔹 Lucas — AWS (Zapay / Olho no Carro) + Argo/GitOps

- **Papel:** trabalha junto com Mateus na Zapay/Olho no Carro. Focado também em Argo, GitOps e NAT Gateway.
- **Cloud principal:** AWS (Zapay, Olho no Carro).
- **Projetos recorrentes:** Olho no Carro (migração), NAT Gateway (atualização em dev/hml/prod), Argo/GitOps (Wellington quer envolver ele e Felipe nisso).
- **Frase que resume:** dupla com Mateus na AWS. Quando envolver GitOps/Argo na Zapay, Lucas lidera.

---

## 🔹 Ítalo — Afinz/Carvalt + CA Interna

- **Papel:** ponto focal do projeto Afinz/Carvalt (empresa adquirida). Também responsável pela atualização da Root CA interna.
- **Cloud principal:** AWS (Afinz — 4 contas), mas CA interna é cross-cloud.
- **Projetos recorrentes:** Afinz (EKS + Lambda + Transit Gateway + Fiserv/Mastercard), Root CA (atualização, levantamento de certificados, data crítica 28/06/2027).
- **Frase que resume:** Afinz é o primeiro projeto grande dele. E a CA interna que ele atualizou afeta todo mundo.

---

## 🔹 Essias — GCP / Secrets / Alertas

- **Papel:** atua em limpeza de secrets, auditoria de segurança e ajuste de alertas no ambiente GCP.
- **Cloud principal:** GCP (Gringo).
- **Projetos recorrentes:** rotação e limpeza de secrets GCP (~529 sem uso), alertas Dynatrace no NAF3, Okta + Cloud Identity, apoio em segurança.
- **Frase que resume:** quando Wellington precisa de auditoria ou limpeza de segurança no GCP, Essias executa.

---

## 🔹 Felipe — Azure + AWS + Rancher + Certificados

- **Papel:** execução de chamados (Azure, AWS), governança RBAC no Rancher, rotação de certificados, inventário de cluster tools. Recebendo cada vez mais tarefas da Zapay/Olho no Carro por delegação de Wellington.
- **Cloud principal:** Azure (Sem Parar) e AWS (Sem Parar + apoio Zapay/Olho no Carro).
- **Projetos recorrentes:** chamados de provisionamento Azure (Web App, ACR, PostgreSQL, API Gateway), RBAC Rancher, rotação de certificados (aguardando Wellington), inventário de ferramentas do cluster (com Thiago), certificados AWS (ACM).
- **Frase que resume:** estou ampliando escopo — de Azure/chamados para Rancher, certificados e suporte à Zapay. Wellington está me envolvendo progressivamente.

---

## 🤝 Pessoas externas recorrentes nas reuniões

| Nome                          | Contexto                                                                                                    |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Isaú**                      | SRE — recebe passagem de conhecimento, ponto de contato para comunicar devs sobre CA                        |
| **Kleber**                    | Tem aplicação que é case de uso do template Backstage                                                       |
| **Diogo**                     | Executa mudanças no F5 (load balancer de rede)                                                              |
| **Aurélio**                   | Time VB — acompanha e testa changes de migração de rede                                                     |
| **Tales**                     | SI (Segurança da Informação) — envolvido em rotação de secrets e decisões de WAF/Imperva                    |
| **Jonathan**                  | Gringo (operação) — envolvido em BigQuery, Elastic, PCI audit                                               |
| **Zaza**                      | DevOps — migração de código/infra para GitHub                                                               |
| **Yasu**                      | Gringo — apoiou Thiago na criação do repositório de IaC                                                     |
| **Feitosa**                   | Time do cliente (NAF3) — alertas Dynatrace                                                                  |
| **Gabriel Anderson Graani**   | Contato AWS na Afinz                                                                                        |
| **João Barth / Luiz Vinholi** | Equipe de desenvolvimento AI Agents App — contato para tasks Azure                                          |
| **Deivison**                  | Gestão Compass UOL — assuntos de PDI, timesheet, banco de horas                                             |
| **Guilherme**                 | Gestão/capacity — sizing de node pools e infra                                                              |
| **Caio Cruvinel**             | Novo Account Manager do Google para a conta Gringo (alocado em maio/2026)                                   |
| **Caio Proviel**              | Contato técnico na Gringo — validações de descomissionamento de recursos                                    |
| **Caio Medice**               | Account Manager do Google — procurando Léo para reunião de alinhamento de demandas                          |
| **Clayton**                   | Gestão/cronograma na Afinz/Carvalt — ponto de contato para planejamento de entregas                         |
| **Aparecida (Cida)**          | Gestão na Afinz — envolvida em cronograma e acompanhamento                                                  |
| **Hélio**                     | Gringo — solicitou desligamento do Analyze (Dynatrace) em staging                                           |
| **Ênio**                      | Contato para janela de configuração do Okta no GCP                                                          |
| **Joson**                     | Solicitante externo — pediu adição de headers em API Gateway (Dev/HML/Prod)                                 |
| **Hudson**                    | Head/Gestor da área de dados (perfil mais de negócios/marketing)                                            |
| **André**                     | Envolvido na discussão sobre coexistência de domínios e nós no Okta                                         |
| **Célio e Ian**               | Equipe de desenvolvimento/esteira no GCP (deploy e secrets)                                                 |
| **Luciano**                   | Ponto de contato sobre configuração de DNS interno e rotas estáticas                                        |
| **Rafael Humberto**           | Envolvido na certificação PCI da Gringo — mapeamento de fluxo de dados                                      |
| **Rodolfo**                   | Contato da área de dados (Gringo Data) — responsável por BigQuery e reservas                                |
| **Leandro**                   | Gestão de Change — acompanha projetos como NAT Gateway e CPP                                                |
| **Diego Ferraz**              | Tech Lead externo do Olho no Carro — trata Mateus como DevOps (problema recorrente)                         |
| **Jessé**                     | SI (Segurança da Informação) — pressiona sobre certificação PCI Gringo e segregação                         |
| **Noio**                      | Contato Okta — responsável por entregar credenciais de configuração                                         |
| **Luiz**                      | Desenvolvedor — pediu atualização de Secret; caso de uso que evidenciou necessidade de canal de comunicação |
| **Itamar**                    | Responsável por chamado de monitoramento (Elastic/Dynatrace) — tarefa pendente pós-Change                   |
| **Gabriel (Olho no Carro)**   | Dev do time externo do Olho no Carro — carioca, participou da reunião de alinhamento                        |
| **Argentino (Rio/Cloud)**     | Representante do Google Cloud na América Latina — vem ao Brasil para workshop em julho                      |
| **Darcimara**                 | Gestora do time de dados da Afinz/Carvalt — time não engaja nas reuniões de quarta                          |
| **Maracanã**                  | Contato/gestor no Olho no Carro — acionado por Rafael Humberto para dar tração ao projeto                   |
| **Erlani**                    | Arquitetura — pode ter contato na Caixa pré-pago para liberação de IPs do NAT Gateway                       |
| **Everton**                   | Ex-membro do time de Network (Diogo) — saiu da empresa, deixando gap no time                                |

---

> [!note] Atualização
> Essa nota é atualizada conforme novas reuniões adicionam contexto. Última atualização baseada na reunião de [[16-06-2026]] e [[23-06-2026]].
