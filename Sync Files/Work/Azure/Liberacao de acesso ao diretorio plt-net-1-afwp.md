---
tags: [task, azure, firewall, acesso, network]
status: em andamento
criado: 2026-05-11
---

Chamado: TASK1247601

# TASK1247601 — Liberação de Acesso ao Diretório plt-net-1-afwp no Azure

---

## 📋 Descrição Original

> Solicito a liberação de acesso no Azure para o diretório `plt-net-1-afwp`, necessária para a execução de regras de firewall e validação do ambiente.

---

## 🧠 Entendendo a Task

> *Antes de executar, entenda. O cérebro retém melhor quando conecta o novo ao que já conhece.*

### Por que essa task existe?

Alguém precisa mexer em regras de firewall e validar um ambiente no Azure, mas não tem permissão de acesso ao diretório `plt-net-1-afwp`. Sem esse acesso, o trabalho trava. Essa task é um desbloqueio — você vai garantir que a pessoa certa tenha a permissão certa para seguir em frente.

### O que está sendo solicitado?

É uma task simples e direta — **um único recurso, uma única ação**:

| O quê | Onde | Para quê |
|---|---|---|
| Liberação de acesso | Diretório `plt-net-1-afwp` no Azure | Execução de regras de firewall e validação do ambiente |

> 💡 **Âncora mental:** `plt-net-1-afwp` — o prefixo `plt-net` já diz tudo: é um recurso de **plataforma de rede**. Faz sentido que seja gerenciado via firewall.

### O que você precisa saber antes de executar

- **Quem está solicitando o acesso?** — Identifique o usuário ou service principal que precisa da permissão.
- **Qual nível de acesso é necessário?** — Leitura, escrita, ou controle total? Regras de firewall normalmente exigem pelo menos permissão de **Contributor** no recurso ou **Network Contributor** na subscription/RG.
- **Em qual subscription/RG está o `plt-net-1-afwp`?** — Confirme antes de conceder para não errar o escopo.

### Perguntas-guia para não errar

- [ ] Identifiquei quem (usuário/grupo/service principal) receberá o acesso?
- [ ] Confirmei o nível de permissão necessário (Reader / Contributor / Network Contributor)?
- [ ] Confirmei a subscription e o Resource Group onde o diretório `plt-net-1-afwp` está?
- [ ] O acesso foi concedido no escopo correto (não mais amplo do que necessário)?
- [ ] Validei com o solicitante que o acesso está funcional após a liberação?

---

## 📝 Minhas Anotações

> *Use esse espaço enquanto executa: prints, observações, erros encontrados, decisões tomadas.*

---

A tarefa já tinha sido feita pelo Thiago.