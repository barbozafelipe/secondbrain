---
tags: [projeto, ia, mcp, automação, pessoal]
status: 🟡 em andamento
início: 2026-06-02
---

# 🧠 Second Brain Agent

> Assistente pessoal de IA conectado ao meu Obsidian, agenda e e-mail via MCPs.
> Inspirado no projeto **Stra** do Wellington ([[02-06-2026]]).

---

## 💡 Por que estou fazendo isso

1. **Problema real**: mantenho um vault Obsidian com reuniões, tarefas, estudos — mas gasto tempo demais processando, buscando e organizando informação manualmente.
2. **Desenvolvimento profissional**: o Wellington quer que o time todo participe do projeto Stra (AI Agents para o squad). Aprendendo MCP + agentes aqui, chego lá com experiência prática.
3. **Visão**: quero que toda manhã um agente me entregue um briefing do dia — agenda, pendências, insights — sem eu precisar abrir 5 apps diferentes.

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────┐
│        Claude Desktop           │
│     (agente principal)          │
├─────────────────────────────────┤
│                                 │
│  ┌──────────┐  ┌──────────┐    │
│  │   MCP    │  │   MCP    │    │
│  │Filesystem│  │ Google   │    │
│  │(Obsidian)│  │ Calendar │    │
│  └──────────┘  └──────────┘    │
│                                 │
│  ┌──────────┐  ┌──────────┐    │
│  │   MCP    │  │   MCP    │    │
│  │  Gmail   │  │ Browser  │    │
│  └──────────┘  └──────────┘    │
│                                 │
└─────────────────────────────────┘
```

---

## 🗺️ Roadmap

### Fase 1 — Vault Reader (Semana 1-2) ✅ COMEÇAR AQUI

> **Objetivo**: agente que lê o vault Obsidian e responde perguntas sobre o meu trabalho.

- [ ] Instalar Claude Desktop (se ainda não tiver)
- [ ] Configurar MCP Filesystem apontando para o vault
- [ ] Criar o projeto no Claude com o prompt base ([[Prompt — Second Brain Agent]])
- [ ] Testar perguntas básicas:
  - "Quais ações pendentes tenho das reuniões?"
  - "O que o Wellington delegou pra mim no último mês?"
  - "Me faz um resumo de tudo sobre certificados"
- [ ] Testar processamento de reunião (dar a transcrição e pedir pra formatar)

**Entregável**: agente funcional que consulta o vault e processa reuniões.

---

### Fase 2 — Vault Writer (Semana 3-4)

> **Objetivo**: agente que não só lê, mas **escreve** notas no vault.

- [ ] Habilitar escrita no MCP Filesystem
- [ ] Criar template de reunião como referência para o agente
- [ ] Testar criação automática de notas:
  - Processar transcrição → gerar nota no formato padrão → salvar no vault
  - Criar nota de ação a partir de uma reunião
- [ ] Criar template de briefing diário

**Entregável**: agente que processa reuniões e salva a nota direto no vault.

---

### Fase 3 — Agenda (Mês 2)

> **Objetivo**: conectar o Google Calendar para o agente saber o que tem no dia.

- [ ] Instalar e configurar MCP Google Calendar
- [ ] Testar leitura: "o que tenho hoje?", "semana que vem tá pesada?"
- [ ] Testar escrita: "marca 1:1 com Wellington quinta 15h"
- [ ] Integrar com briefing diário (agenda + pendências do vault)

**Entregável**: briefing diário com agenda + tarefas pendentes.

---

### Fase 4 — E-mail (Mês 3)

> **Objetivo**: agente lê e-mails e extrai informações relevantes.

- [ ] Instalar e configurar MCP Gmail
- [ ] Testar: "chegou algo do convênio?", "resumo dos e-mails da semana"
- [ ] Integrar com briefing: alertas de e-mails importantes que não respondi

**Entregável**: briefing completo — agenda + tarefas + e-mails pendentes.

---

### Fase 5 — Orquestrador (Mês 4+)

> **Objetivo**: automação completa. Briefing diário gerado e salvo no vault automaticamente.

- [ ] Criar prompt de orquestração que combina todas as fontes
- [ ] Automatizar execução (cron ou trigger manual)
- [ ] Refinar formato do briefing com base no uso real
- [ ] Explorar: notificações via Telegram/WhatsApp

**Entregável**: sistema autônomo de briefing pessoal.

---

## 📊 O que vou aprender (e levar pro trabalho)

| Skill aprendida aqui | Aplicação no Stra (trabalho) |
|---|---|
| Configurar MCPs | Configurar MCP Kubernetes, MCP ArgoCD |
| Escrever prompts de agente | Prompts do agente SRE, Cloud Architect |
| Criar skills/tools | Skills de troubleshooting K8s |
| Orquestrar múltiplos MCPs | Orquestrador Spectra |
| Tratar erros e edge cases | Agentes robustos em produção |

---

## 📚 Referências

- [[Prompt — Second Brain Agent]] — prompt base do agente
- [[Configuração MCP]] — como configurar os MCPs no Claude Desktop
- [[02-06-2026]] — reunião onde Wellington apresentou o projeto Stra
- [MCP - Documentação oficial](https://modelcontextprotocol.io)
- [MCP Servers - repositório](https://github.com/modelcontextprotocol/servers)

---

> [!tip] Filosofia
> Começar pequeno, com necessidade real. Não criar uma porrada de coisa na cabeça — ir observando o dia a dia e implementando conforme a necessidade. (O próprio Wellington falou isso na reunião.)
