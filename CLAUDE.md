# CLAUDE.md — Second Brain do Felipe

> Fonte da verdade do vault. Lido no início de toda sessão (referenciado no `~/.claude/CLAUDE.md` global).
> Mantém skills, pastas e queries alinhados. Se algo aqui divergir da realidade, **a realidade vence — corrija este arquivo.**

## Quem é o Felipe
- Analista de Infra Cloud (Sem Parar / Corpay). Trabalha com Azure, AWS, GCP, OCI, Okta, Zscaler, Rancher/K8s, Terraform.
- Vault é um LifeOS: trabalho + estudo + saúde + projetos pessoais num lugar só.
- **Metas físicas:** 80 kg de massa magra · Índice de Adonis (ombro/cintura ~1.618). Pele acne-prone em acompanhamento.
- **Exige honestidade brutal.** Nada de suavizar números, progresso ou diagnóstico. Delta real vs meta, sempre.

## Regra de dia da semana (CRÍTICA)
**Sempre calcule o dia da semana — nunca chute.** A rotina depende disso:
- **Seg / Qua / Sex** → dia de treino (academia).
- **Ter / Qui** → dia presencial no trabalho (acorda 6h, prioridades de trabalho primeiro).

## Estrutura real do vault (mapa canônico)
Tudo de conteúdo mora sob `Sync Files/`. **Use estes caminhos reais** — não invente `diário/`, `infra/`, `research/` etc.

| Domínio | Pasta |
|---|---|
| Daily notes | `Sync Files/Diário/` (`YYYY-MM-DD.md`) |
| Captura rápida / ambíguo | `Sync Files/Inbox/` |
| Trabalho — Azure/AWS/GCP/OCI/Okta/Zscaler/Rancher | `Sync Files/Work/<Provider>/` |
| Trabalho — certificados | `Sync Files/Work/Certificados/` |
| Trabalho — carreira / 1:1 / feedback | `Sync Files/Work/Carreira/Sem Parar - Corpay/` |
| Reuniões semanais | `Sync Files/Work/Reuniões semanais/` |
| Estudos / certificações | `Sync Files/Estudos/` |
| Médico (consultas, exames) | `Sync Files/Médico/<Especialidade>/` |
| Treino & físico (hub) | `Sync Files/Pessoal/Academia.md` |
| Saúde / clínico (hub) | `Sync Files/Pessoal/Saúde.md` |
| Log de medidas corporais | `Sync Files/Pessoal/Medidas.md` |
| Projeto Draco | `Sync Files/Projetos/Draco/` |
| Projeto Second Brain | `Sync Files/Projetos/Second Brain Agent/` |
| Vida pessoal (geral) | `Sync Files/Pessoal/` |

Hubs em `Sync Files/Pessoal/` (notas-âncora, não mexer sem motivo): `Academia`, `Saúde`, `Financeiro`, `Vida profissional`, `Plano de vida`, `Identidade & História`, `Relationship`, `Setup`.

## Padrão de frontmatter ("write once, surface everywhere")
Toda nota criada por skill deve carregar frontmatter consistente — é isso que faz as queries Dataview funcionarem sozinhas.

```yaml
---
tipo: daily | nota | tldr | medida | reuniao | medico | task | estudo | projeto | hub
criado: YYYY-MM-DD
tags: [domínio, tecnologia, ...]
status: ativo        # opcional: ativo | concluido | arquivado
fonte: conversa-claude   # opcional, para notas de auto-brain
---
```

### Campos inline (Dataview) para o físico
Logar peso no daily note via campo inline faz ele aparecer sozinho no Fitness Dashboard:
- `peso:: 75.2` — peso do dia (kg)
- `mm:: 70` — massa magra estimada (kg), opcional
- `treino:: Push` — grupo treinado no dia

Medidas corporais completas (cintura, ombros, BF%) vão na tabela de [[Medidas]].

## Surface layer (Dataview — já instalado)
- `Dashboard.md` (raiz) — hoje, inbox a processar, notas recentes, TODOs abertos.
- `Sync Files/Pessoal/Fitness Dashboard.md` — tendência de peso, consistência de treino, link pras medidas.

Para abrir o Dashboard ao iniciar o Obsidian: plugin **Homepage** → definir `Dashboard` como homepage.

## Skills
| Skill | O que faz |
|---|---|
| `/daily` | Abre/cria daily note de hoje, checa inbox, surface metas, pergunta foco. |
| `/fitness` | Delta brutal vs metas (80kg MM, Adonis) a partir de Academia/Saúde/Medidas + dailies. |
| `/tldr` | Salva resumo da sessão na pasta certa (roteamento real). |
| `auto-brain` | No fim da conversa, destila conhecimento pertinente em nota com frontmatter + dedup. |

## Convenções de nota (do auto-brain)
- TL;DR de 1-2 frases no topo do corpo.
- Profundidade média (~300-500 tokens); detalhada com código/tabelas para troubleshooting.
- Wikilinks `[[Nome]]` para conectar.
- **Nunca editar blocos `%% Begin Waypoint %%`** — o plugin atualiza sozinho.
- Deduplicar antes de criar: atualizar nota existente > criar duplicata.
