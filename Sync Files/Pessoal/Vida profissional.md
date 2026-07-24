# Vida Profissional

> Trajetória de carreira, emprego atual, atuação técnica, equipe, processos de trabalho e plano de desenvolvimento (PDI).
> Relacionado: [[Plano de vida]], [[Financeiro]], [[Saúde]].

## Trajetória de carreira
- 16 anos: comecei a trabalhar em marcenaria com meu pai.
- 19 anos: iniciei faculdade de Cyber Segurança na Impacta.
- Pouco antes dos 20: suporte ao cliente em empresa de internet.
- Set/2023: estágio na Service IT (virtualização → redes → cloud); me apaixonei por cloud.
- Out/2024: efetivado como Analista de Cloud Júnior na Service IT.
- Mai/2025: desligado.
- ~2 semanas depois: SkyOne, Analista de Implantação Júnior; desligado após 3 meses.
- 17/11/2025: emprego atual — **Engenheiro Cloud Pleno pela Compass UOL**, alocado na **Sem Parar/Corpay**.

## Emprego atual
- **Contratante**: Compass UOL. **Cliente/alocação**: Sem Parar/Corpay.
- **Regime híbrido**: presencial terças e quintas (9h–18h); remoto nos demais dias.
- Sem metas individuais na Compass — contribuo para as metas da Sem Parar, sem participação direta no PPR deles.
- **PPR da Compass**: não considerar no planejamento enquanto não confirmado e depositado (ver [[Financeiro]]).

## Atuação técnica
Cloud Engineer em ambiente multi-cloud (**AWS, Azure e OCI**) em um dos maiores ecossistemas de mobilidade e pagamentos da América Latina. Squad de infraestrutura responsável por +30 contas AWS e múltiplas subscriptions Azure.
- **Responsabilidades principais no cliente: Azure e OCI** (responsável principal).
- IaC com **Terraform**: módulos, troubleshooting de states, provisionamento ponta a ponta.
- Design de infra para iniciativas de **IA (AI Agents)**: Azure Cognitive Services, Web/Function Apps, Container Registries, Cosmos DB, PostgreSQL Flexible Server.
- **Redes e Segurança Cloud**: VNet Integration, Subnet Delegation, Private DNS Zones, roteamento avançado, isolamento de tráfego em NPROD/HML/PRD.
- Governança de clusters **Kubernetes via Rancher/RKE** (RBAC, padronização).
- Gestão de **certificados TLS** na AWS (ACM) e Azure, incluindo SAN multi-domínio, junto à Segurança da Informação (Imperva/WAF).

## Contexto dos clientes do squad
- **Sem Parar** = AWS + Azure + OCI (minha alocação principal).
- **Gringo** = GCP · **Zapay + Olho no Carro** = AWS · **Afinz/Carvalt** = AWS (em migração).

## Equipe e pessoas
| Pessoa                  | Papel                                                                                              | Observações                                                                                                         |
| ----------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Wellington**          | Tech Lead / Arquitetura (cliente)                                                                  | ~40 anos, pai de família. Delega tarefas progressivamente (simples → complexas). Lidera o projeto Stra (AI Agents). |
| **Guilherme**           | Gestor do cliente (Sem Parar/Corpay)                                                               | Direto e prático. Controla banco de horas de terceiros em planilha. Feedback positivo sobre mim.                    |
| **Deivison**            | Meu gestor na Compass                                                                              | Canal aberto via Teams. Cadência: 1:1 ~90 dias + updates assíncronos a cada 15 dias.                                |
| **Humberto Lopes**      | Gestor Compass (par do Deivison)                                                                   | Vai ao Sem Parar Seg/Qua; ocasionalmente Ter/Qui.                                                                   |
| **Thiago**              | Apoio técnico (Azure/OCI/K8s/Networking)                                                           | ~30 anos. Muito solícito. Meu principal apoio técnico.                                                              |
| **João Pedro ("João")** | GCP / FinOps                                                                                       | ~30 anos.                                                                                                           |
| **Lucas**               | AWS / Argo / GitOps                                                                                | Nascido em 1999 (o mais novo da equipe, depois de mim).                                                             |
| Outros                  | Mateus, Ítalo, Ian (GKE), Leonardo ("Léo", cobra o time, é o diretor de infraestrutura da empresa) | Contatos recorrentes do squad.                                                                                       |

Convívio social mais frequente com Thiago, João e Lucas (almoços, saídas).

## Processos de trabalho
- **Ponto (Compass)**: ferramenta **Ahgora** — 4 batidas diárias, sem edição retroativa. Bater todos os dias.
- **Banco de horas duplo**: ponto formal da Compass (CLT) + planilha informal do Guilherme (cliente). Atualmente **−8h** com o Guilherme (emenda de feriado em 02/jan); ele consome essas horas em atividades estratégicas (Change noturna / fim de semana).
- **Hora extra** só com autorização explícita de Guilherme ou Wellington. Compensação de horas ao cliente **não** entra no ponto da Compass.
- Qualquer combinado com o cliente → avisar Deivison **antes**.
- **PDI** no Qulture.Rocks (SSO `compass-uol`).

## Feedback recebido
- Guilherme satisfeito ("troca ganha-ganha"); repassou feedback positivo ao Deivison.

## Dinâmica social na equipe
- Sou o **mais novo do squad** (2003) e com **menos senioridade técnica** — em processo de crescimento e delegação progressiva.
- Trabalho a presença social de forma intencional (participar em pequenas doses); a percepção da equipe sobre mim muda silenciosamente a cada boa entrega técnica.

## Projetos / frentes atuais (jun/2026)
- **Rotação de certificados TLS** em clusters RKE não-produtivos: fazer 1–2 junto com o Wellington e depois seguir solo (coordenado também com o Thiago).
- Apoio a **Zapay / Olho no Carro** (DNS, novas entradas) quando Lucas/Mateus precisarem.
- **GKE Standard**: previsto voltar a trabalhar com o Ian após a fase de Secrets.
- **Projeto Stra (AI Agents)** do Wellington: oportunidade de participar (sessões semanais).

## PDI — metas de desenvolvimento
| Meta                                       | Prazo      | Status                                                                                                                                                 |
| ------------------------------------------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Trilha Sem Parar (ESG, LGPD, Assédio)      | 29/05/2026 | Concluído                                                                                                                                              |
| AWS Certified Cloud Practitioner (CLF-C02) | 31/08/2026 | Prova agendada para 22/08/2026 · 1º simulado em 06/07: **132/200** · **plano de estudos v3 ativo** (recalibrado em 24/07 após semana sem estudo + cirurgia em 05/08) · análise por domínio concluída (ver abaixo)             |
| Especialização Terraform (Azure + OCI)     | 31/10/2026 | Não iniciado                                                                                                                                           |
| Ciclo de Inglês Técnico (30h)              | 18/12/2026 | Em progresso, mas cancelei as aulas por questões financeiras com o professor, e não posso voltar a ter aulas tão cedo ainda... não sei como vou fazer. |

**TODO / conflito a resolver:** a decisão financeira de "pausar aulas de inglês até setembro de 2026" (ver [[Financeiro]]) conflita com a meta de Inglês do PDI (em progresso, prazo 18/12/2026). Alinhar.

### CLF-C02 — acompanhamento
- **06/07/2026 — 1º simulado** (AWS Skill Builder Assessment, 31 questões): **132/200 — nível "Estabelecido", percentil 74**.
- **Acurácia real por domínio** (cruzando resultado detalhado com autoavaliação de confiança por questão):
  - Cloud Concepts: 8/8 (100%)
  - Billing and Pricing: 4/5 (80%)
  - Security: 6/8 (75%)
  - **Technology: 5/10 (50%) — domínio mais fraco, maior peso na prova real (34%)**
- **Erros de alta confiança (falso conhecimento — prioridade máxima de revisão):**
  - Q5 (Billing, 70% conf.): Cost and Usage Reports vs. AWS Cost Explorer (entrega de relatório no S3)
  - Q11 (Security, 70% conf.): melhores práticas de IAM (confundiu "excluir conta raiz" com práticas corretas)
  - Q4 (Technology, 65% conf.): vantagens do RDS vs. banco de dados no EC2
- **Lacunas de conteúdo puro (baixa confiança + errou):** AWS Storage Gateway (Q7), AWS Config (Q20), AWS Trusted Advisor (Q24).
- **Padrão identificado:** tendência a se subestimar — 8 questões com confiança ≤25% foram acertadas (Q2, Q6, Q14, Q15, Q18, Q19, Q22, Q29).
- Resta **1 tentativa** do assessment — reservada para ~16/08 como medição de progresso.
- **08/07/2026 — 1ª sessão de banco de questões** (20min): 4 questões, 2 acertos / 2 erros. Os 2 erros repetiram exatamente os gaps já mapeados: **AWS Trusted Advisor** (limites de serviço) confundido com Systems Manager, e **AWS Config** (compliance de configuração) confundido com Service Catalog. **Padrão confirmado: bloco de governança/gestão (AWS Config, Trusted Advisor, Service Catalog, Systems Manager, CloudFormation) é a lacuna mais consistente — 2ª/3ª vez que confunde essas ferramentas entre si.** Precisa de rodada extra dedicada a diferenciar essas 5.
- **RDS/Multi-AZ**: aprofundou bastante por demanda de trabalho (colega pediu ajuda em conta AWS real), estudou e desenhou no Excalidraw as topologias completas (Aurora Serverless v2, Aurora Provisionado, Multi-AZ Cluster, Multi-AZ Standby, Single-AZ com/sem read replica) — nível Solutions Architect, acima do que CLF-C02 exige. Base de RDS está sólida; a sessão de domingo 26/07 (Bancos de Dados) pode ser mais curta/focada só no que é específico de prova.
- **13–20/07/2026: semana sem estudo** — hábito pausado por completo. Sem culpa, sem tentativa de compensar; o plano v3 abaixo já parte da realidade (não infla volume para recuperar o tempo perdido).
- **24/07/2026 — 2ª sessão dedicada a governança** (Config, Trusted Advisor, Service Catalog, Systems Manager, CloudFormation): melhora frente à sessão de 08/07, mas ainda confunde na hora de diferenciar "notificação automática de desvio de configuração" (**AWS Config**) de "checagem periódica geral de boas práticas" (**AWS Trusted Advisor**). **3ª rodada seguida com dificuldade nesse bloco — vira prioridade #1 do plano v3**, junto com AWS Storage Gateway.
- **05/08/2026 (Qua) — cirurgia de septoplastia + turbinoplastia.** Bloqueio de estudo de 05/08 a 08/08 (cirurgia + recuperação). Retomada leve a partir de 10/08, sem tentar compensar os dias perdidos.
- **Plano de estudos v3** (recalibrado em 24/07/2026, considerando a semana sem estudo de 13–20/07 e a cirurgia de 05/08 — sessões continuam curtas, sem inflar volume):
  - Seg/Qua/Sex 8h00–8h20 (dias remotos): banco de questões curto, com prioridade total no bloco de governança (Config/Trusted Advisor/Service Catalog/SSM/CloudFormation) e Storage Gateway até sentir domínio real; depois volta à rotação geral de revisão.
  - **Dom 26/07**: Bancos de Dados — sessão curta, só o que é específico da prova (base de RDS já está acima do exigido).
  - **Dom 02/08**: Well-Architected Framework + Ecosystem.
  - **Seg 03/08**: última sessão de banco de questões antes da cirurgia.
  - **05/08 a 08/08 (Qua–Sáb): zero estudo** — cirurgia + recuperação.
  - **Seg 10/08**: retomada leve — banco de questões, reforço em governança/Storage Gateway.
  - **Qua 12/08**: Official Practice Question Set (AWS Skill Builder) — pode ser um pouco mais longa, dividir em duas se preferir.
  - **Sex 14/08**: revisão rápida geral.
  - **Dom 16/08**: **2ª e última tentativa do assessment oficial** — medição real de progresso.
  - **Semana final 17–21/08**: revisão distribuída por domínio (ver [[CLF-C02 - Revisão Final]], datas já corrigidas para a prova real de 22/08). **Sex 21/08 = zero estudo**, descanso total antes da prova.
  - **Sáb 22/08: PROVA.**
  - Consistência antes de volume; sessão perdida não se compensa nem acumula (mantido do v2).

---
_Atualizado: 2026-07-24 · Fonte: notas pessoais + vault de trabalho (Carreira, PDI, reuniões semanais)._
