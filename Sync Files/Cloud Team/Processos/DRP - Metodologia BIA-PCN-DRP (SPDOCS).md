---
tags: [trabalho, sem-parar, zapei, drp, bia, pcn, risco, processo, padrão]
data: 2026-07-22
---

# DRP - Metodologia BIA → PCN → DRP (SPDOCS)

> [!info] Contexto
> A Sem Parar já tem um DRP oficial como instituição de pagamento. A **SPDOCS** (que engloba ZAPEI, Gringo e Olho no Carro) precisa instanciar o mesmo modelo/template para os seus próprios produtos. O processo é conduzido por **Tibúrcio** (TI, dono do DRP e dos testes/PCN) e **Tati** (Risco e Controles Internos, dona da BIA). Uma consultoria (**Protiviti**) foi contratada para conduzir a BIA de toda a SPDOCS.
>
> Explicado por Tibúrcio para Felipe em reunião de 2026-07-22, no contexto da instanciação do DRP focado em **ZAPEI + débitos de veículo**.

---

## ⚡ TL;DR — o que importa

1. O ciclo segue **PDCA**: BIA → definir política/estratégia → escrever PCN e DRP → testes/exercícios → feedback (volta pro início).
2. **BIA** (Business Impact Analysis) = mapeia processos, sistemas, RTO. **PCN** (Plano de Continuidade de Negócio) e **DRP** (Disaster Recovery Plan) = os planos escritos a partir da BIA. Tati cuida da BIA; Tibúrcio cuida do PCN/DRP e dos testes.
3. Hoje só existe instância para **ZAPEI + débitos de veículo**. Gringo e Olho no Carro ficam para depois (meta: ter os três instanciados até o fim de 2026). Gringo provavelmente vai ficar com o João; Olho no Carro nem entra na conversa agora — está na mesma organização AWS do ZAPEI, mas fora de escopo.
4. RTO padrão usado: **< 4 horas** (a maioria das referências de mercado fala em >8h — é um diferencial).
5. Ainda **não existe teste de DR realizado** para esse escopo — a ideia é rodar um teste de nuvem (AWS) no último trimestre de 2026 (Q4), decisão pendente de quando Eliton voltar de férias (definir abordagem por availability zone vs. availability region).
6. Tibúrcio mantém um **status mensal ("one page")**, atualizado perto do dia 25 de cada mês.

---

## 🗂️ Estrutura padrão do documento DRP

1. **Introdução / conceito PDCA** — como o ciclo BIA → política → PCN/DRP → testes → feedback funciona.
2. **Definições e políticas** — treinamento, periodicidade dos testes, etc. (texto padrão, reaproveitado entre instâncias).
3. **Sistemas críticos** — lista de sistemas identificados, processo, objetivo do processo, principais sistemas, RTO e justificativa, data do último teste.
4. **Descrição do ambiente** — datacenter vs. nuvem, contas, topologia, bancos de dados, forma de acesso (ex: VPN + usuário/senha do sistema). **Esta é a seção 6, onde entra a parte de ZAPAY/AWS que o Felipe está escrevendo.**
5. **Plano de teste** — cronograma geral de testes.
6. **Glossário, referências, anexos, histórico de revisões.**

> [!tip] Fontes reaproveitadas
> Boa parte do conteúdo (RTO, justificativas, sistemas) veio da BIA anterior feita com a Júlia (trabalho iniciado em agosto/2025), citada como referência/anexo.

---

## 🔁 Fluxo de um teste de DR (o que o Tibúrcio faz a cada ciclo)

1. Convoca os envolvidos, define **escopo** e **time** que participa do teste.
2. Monta um **cronograma/planilha passo a passo** por sistema (ex: autorizador CTF, autorizador Credi).
3. Para cada sistema, desenha a **topologia** do ambiente: produção vs. contingência (às vezes misto — ex: bancos no DC2 e autorizadores na nuvem WES), incluindo microsserviços quando existem.
4. Roda o teste com os usuários, medindo o tempo — o dado crítico é o **RTO da infraestrutura**.
5. Documenta em um **relatório de evidências** (com prints/passos da planilha) + **plano de ação** para os pontos críticos encontrados.
6. Também documenta os **procedimentos operacionais** usados (ex: passar o banco de contingência de read-only para read-write, subir a aplicação).
7. O relatório final é assinado por **Leo** e **Escridel**.

---

## 📅 Cronograma / cadência de acompanhamento

- Status mensal ("one page") atualizado perto do dia **25** de cada mês, apresentado em reuniões pelo Leo.
- Status por trimestre (Q1–Q4) do que foi concluído/está em andamento.
- Marcos conhecidos:
  - BIA (assessment inicial) → já concluída.
  - BIA detalhada com Protiviti → em andamento (kickoff 2026-07-16, reunião com operações em 2026-07-17, reunião com regulatório em 2026-07-21 após remarcação).
  - Teste de DR do ERP → previsto para **2026-08-10** (combinado).
  - Teste de PIX automático (autorizadores) → em andamento na tarde de 2026-07-22.
  - Teste de nuvem (AWS, ZAPEI) → planejado para **Q4/2026**, pendente de alinhamento com Eliton.

---

## 👥 Pessoas-chave

| Pessoa | Papel |
|---|---|
| **Tibúrcio** | Dono do PCN/DRP e dos testes; escreve o documento, conduz o status mensal |
| **Tati** | Risco / Controles Internos, dona da BIA |
| **Protiviti** | Consultoria contratada para a BIA completa da SPDOCS (Zapei, Gringo, Olho no Carro) |
| **Matheus** | Maior conhecimento do ambiente ZAPEI/AWS hoje (estava de férias em 2026-07-22) |
| **Lucas** | Segunda referência de conhecimento do ambiente, backup do Matheus |
| **Eliton** | Vai ajudar a decidir a abordagem do teste de nuvem (AZ vs. região) ao voltar de férias |
| **Guilherme** | Já teve uma primeira reunião produtiva com Tibúrcio sobre o teste de nuvem |
| **Leo / Escridel** | Assinam o relatório final do DRP |
| **João** | Provável responsável futuro pela instância do DRP do Gringo |
| **Felipe** | Escrevendo a seção 6 (ambiente computacional AWS) do DRP de ZAPEI/débitos de veículo |

---

## 📌 Glossário

| Termo | O que é |
|---|---|
| **DRP** | Disaster Recovery Plan — plano de recuperação de desastres, foco técnico/infra |
| **PCN** | Plano de Continuidade de Negócio — cobre a continuidade operacional/negócio, não só a infra |
| **BIA** | Business Impact Analysis — análise que mapeia processos, sistemas e RTO, base para o PCN/DRP |
| **RTO** | Recovery Time Objective — tempo máximo aceitável para restaurar um sistema/processo após um incidente |
| **SPDOCS** | Guarda-chuva que engloba ZAPEI, Gringo e Olho no Carro |
| **ZAPEI** | Produto de débito de veículo, foco desta instância do DRP; ambiente roda em AWS |
| **PDCA** | Plan-Do-Check-Act — ciclo de melhoria contínua usado como espinha dorsal do processo BIA/PCN/DRP |

---

## 🔗 Ver também

- Instância concreta do DRP de ZAPEI (aguardando link do SharePoint do Tibúrcio, com permissão de edição na seção 6) — nota de acompanhamento a ser criada quando o documento estiver disponível.
