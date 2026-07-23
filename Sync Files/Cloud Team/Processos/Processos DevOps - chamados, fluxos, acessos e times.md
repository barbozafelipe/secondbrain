---
tags: [devops, processos, governanca, servicenow, gitflow, change, rollback, acessos, times, referencia]
status: ativo
last_updated: 2026-07-22
---

# Processos DevOps — chamados, fluxos, acessos e times

> [!info] Contexto e fonte
> Levantado em 22/07/2026 a partir do repositório `SemParar-Alm/devops_documentation` (também publicado como site interno em `https://vigilant-doodle-3e5oyrw.pages.github.io/`). Cobre a **governança em volta das pipelines**: como abrir chamado, fluxo de branches, Change, rollback, acessos e quem é responsável por quê.
> Para a **mecânica das pipelines** em si (templates, arquivos de config, como o deploy funciona), ver [[Esteira AWS - mecanica das pipelines (Lambda, SQS-Dynamo, Terraform)]].

---

## 1. Onde encontrar a documentação oficial

| Recurso | Endereço |
|---|---|
| Repositório de documentação | `SemParar-Alm/devops_documentation` |
| Site renderizado (GitHub Pages) | `https://vigilant-doodle-3e5oyrw.pages.github.io/` |
| Repositório de templates | `SemParar-Alm/templates-pipelines-actions` |
| Dashboard de ferramentas | `https://dashboard-containers.dev.ocp.fleetcor.com.br/` |
| Portal DevOps (Backstage) | `https://backstage.corpay.com.br/catalog` |
| Copilot Space da documentação | `https://github.com/copilot/spaces/SemParar-Alm/6` |
| Issues (melhorias de pipeline/processo) | `https://github.com/SemParar-Alm/devops_documentation/issues` |
| Release Notes de DevOps | `release-notes.md` no repositório |

> [!tip] Copilot Spaces
> Existe um Space do Copilot configurado sobre essa documentação (GitHub → ícone Copilot → Spaces → Organizations → devops). Permite perguntar sobre a documentação em linguagem natural. Nem toda documentação está indexada ainda.

---

## 2. Que tipo de chamado abrir — a decisão mais importante

Errar o tipo de chamado atrasa o atendimento (SLA e priorização diferentes). A regra oficial:

| Situação | Tipo | Onde |
|---|---|---|
| Erro/falha na execução de action (build, teste, deploy) | **INCIDENTE** | Service Now → DevOps |
| Nova pipeline, ajuste em action existente, novo repositório | **REQUEST** | Service Now → DevOps |
| Ideia, mudança estrutural de fluxo, sugestão, feedback, nova tecnologia | **ISSUE** | GitHub Issues do `devops_documentation` |

⚠️ **Nuance importante em deploy:** o time de DevOps atua apenas em **falha da action**. Problema de **ambiente** (pod não sobe, servidor fora, etc.) é do time de **SRE**, não DevOps.

### Subtipos de Requisição no Service Now (DevOps)

| Opção | Para quê |
|---|---|
| Novo Repositório de Código Fonte | Criar repositório no GitHub |
| Novo Agente de Build | Criar nova pipeline/action |
| Alteração de Agente Existente | Mudar pipeline/action existente |
| Change Velocity | Incluir aplicação no fluxo de DevOps Change (§5) |

---

## 3. Checklist obrigatório antes de abrir chamado

O time de DevOps espera que estes pontos tenham sido verificados. Vale seguir para não ter o chamado devolvido:

1. **Documentação** — ler a doc do projeto e da tecnologia. Se o erro não estiver documentado, avisar o DevOps para atualizarem.
2. **Versões** — conferir se versões de aplicação/dependências são compatíveis com as da pipeline. Mudança de versão na pipeline exige alinhamento prévio com **Arquitetura** + e-mail ao DevOps. Às vezes é preciso *invalidate cache* (solicitar ao DevOps).
3. **Inputs e configurações** — confirmar que todos os inputs da action foram preenchidos e que arquivos/variáveis/parâmetros do projeto estão corretos (dúvida → TL ou Arquiteto).
4. **Ações e branch** — verificar se outra action da mesma tecnologia apresenta o mesmo erro, e se executou na branch correta.
5. **Ambiente** — testar se o erro ocorre em outros ambientes/branches.
6. **Validação local** — tentar reproduzir localmente (lembrando que cache/variáveis diferem).
7. **Permissões** — conferir se possui as permissões necessárias.

Só depois disso, abrir chamado no Service Now.

---

## 4. Gitflow e validação de Pull Request

### Branches

| Branch | Criada a partir de | Finalidade | Padrão de nome |
|---|---|---|---|
| `feature` | `develop` | Nova funcionalidade | `feature/<funcionalidade>` ou `feature/<num-jira>` |
| `develop` | — | Integração de features; base do desenvolvimento | — |
| `release` | `develop` | Ajustes finais e preparação para produção | `release/<versao>` |
| `master` | — | Código em produção; só recebe merge de `release` ou `hotfix` | — |
| `hotfix` | `master` | Correção crítica em produção; merge em `master` **e** `develop` | `hotfix/<descricao>` ou `hotfix/<num-jira>` |

### Validação automática de PR

Existe uma action `validate-pullrequest.yml` em **todos os repositórios**, que roda automaticamente ao abrir PR. O PR **só pode ser aprovado se ela passar**. Ela valida:

- **Nomenclatura das branches** — feature/hotfix precisam seguir o padrão (nomes pessoais ou genéricos são rejeitados).
- **Direção do fluxo:**
  - PR para `develop` → só de `feature`, `hotfix` ou `release`
  - PR para `release` → só de `develop`
  - PR para `master` → só de `release` ou `hotfix`

Se o PR não estiver conforme, precisa ser fechado e reaberto corretamente. Após merge de feature/hotfix, apagar a branch.

---

## 5. DevOps Change — deploy em PRD sem CAB

Mecanismo para **evitar CAB e aprovação manual de Change**, com a Change sendo criada automaticamente pela própria pipeline.

### Regras para entrar no fluxo

1. Abrir chamado **Change Velocity** no Service Now. A aprovação passa por: **Herlani** → time de **SI** → **SRE** → **DevOps** (quem efetivamente inclui o projeto).
2. Exigência de **90% de cobertura de testes** (motivo da aprovação passar por SI).
3. Fallback automático ocorre **apenas em falha no step de Produção** (ex: pod não sobe). Regra de negócio precisa estar garantida nos testes automatizados.
4. Em caso de sucesso, **o desenvolvedor é responsável por encerrar a Change** (tarefa 999).

### Fluxo de execução

1. Seguir Gitflow.
2. Deploy em DEV normal, pela branch `develop`.
3. Abrir PR para `release` — **a descrição do PR precisa conter o número do Jira**.
4. Após aprovação do PR: deploy em QA → Change criada automaticamente → deploy em PRD.
5. Desenvolvedor encerra a Change.

### Configuração técnica necessária

```yaml
on:
  push:
    branches:
      - "release"
  workflow_dispatch:
```

Mais: variável `DEVOPS_CHANGE = true` no repositório, e remover os environments (ou ao menos o grupo de operações) para que não haja aprovação manual.

⚠️ Não é permitida execução manual na branch `release` — o fluxo só funciona disparado pela aprovação do PR.

---

## 6. Change Validation (deploy normal, fora do DevOps Change)

Step presente nas pipelines que valida a Change antes de deployar em PRD.

**Como funciona:** ao aprovar o deploy em PRD, o time de Produção informa o **número da change no campo "Leave a comment"** da aprovação. O step então valida:

1. Se o campo de comentário foi preenchido;
2. Se a change informada existe;
3. Se o status é válido — **`Implement`** para deploy em PRD, **`Review`** para rollback.

---

## 7. Rollback

O rollback é implementado pelo próprio time (não via *re-run* do GitHub, que só fica disponível por 30 dias).

| Job | O que faz | Aprovação necessária |
|---|---|---|
| `prepare-rollback` | Verifica se existe deploy anterior em PRD; baixa o pacote publicado e re-publica na action atual (ou captura o run anterior, em casos de container/OpenShift) | **SRE** |
| `deploy-rollback` | Executa o deploy da versão anterior (mesmos steps do deploy normal) | **Produção** + Change Validation com status `Review` |

**Casos em que não há rollback disponível:** primeiro deploy da aplicação, ou último deploy em PRD tendo sido feito pelo Azure DevOps (antes da migração). Se o log indicar ausência de rollback mas houver deploy em PRD pelo GitHub, comunicar o DevOps com a URL da action.

⚠️ **Sempre validar se o rollback capturado é o correto** antes de aprovar.

---

## 8. Acessos — como solicitar

### Via Sailpoint (`https://fleetcor.identitynow.com/ui/d/mysailpoint`)

Central de Solicitações → escolher se é para si ou terceiro → buscar o grupo.

**GitHub** — buscar `Github - BR`:

| Grupo | Permissões |
|---|---|
| `BR - GITHUB ARQ` | Todas as Organizations, permissões ilimitadas |
| `BR - GITHUB DEV <ORG>` | Org específica: branch, commit/push, tag, executar actions |
| `BR - GITHUB TECH LEAD <ORG>` | Igual DEV + aprovar PR para `release` e `master` |
| `BR - GITHUB OPERACOES` | SRE e Produção: aprovar deploy em produção |

**AWS** — buscar `AWS - BR`, depois a conta (ex: `USR - BR_AWSABASTECE_DEVELOPER`) e o grupo.

**Outros (via `Diversos - BR`)**: OpenShift (buscar "openshift"), Nexus (`USR - Recurso NEXUS_VIEWERS`), SonarQube (`USR - BR SONARQUBE STD`).

**Copilot**: e-mail para `operations.devops@corpay.com.br`.

---

## 9. Times — quem procurar para quê

> [!tip] Uso prático
> Esta seção resolve ambiguidade de nomes que aparece em transcrições de call e conversas. Útil para saber a quem escalar cada assunto.

### DevOps — pipelines, builds, deploys, ambientes de pipeline
Isaelin Claudino dos Santos · Guilherme Martins Chavenco · Lucas Mucheroni Correia · Celio Evangelista de Jesus · Julio Henrique Almeida Barbosa · Pedro Henrique M de Oliveira · Yassui Azevedo Kimura · Ian Karlo Torres Dos Santos · Thiago David Silva Pereira · Alexsander Torres de Oliveira Pereira (estagiário)

*Todos têm autonomia para atuar em qualquer assunto de pipeline.*

### Cloud — AWS/Azure/GCP/OCI, IaC, redes cloud
Wellington Feitosa · **Felipe Barboza Gonçalves** · Lucas Paulo Gonçalves · João Pedro Baria · Thiago Ferreira de Barros · Essias Alves Souza · Mateus Chagas · Leonardo Martins · Cleber Silva Barbosa · Ithallo Oliveira Nunes

### Arquitetura — decisões técnicas, versões, padrões de projeto
Herlani Antonio Bimbo Junior · Eduardo Koji Yoshida · Roberto D'all. Guimaraes · Ricardo Augusto Parmesan · Wesley Eduardo Da Silveira Pelais · Leonardo Jose Carvalho · Victor Caina Martins · Carlos Henrique Ribeiro · Doogie Dicelis · Renato De Santa Anna do Nascimento Junior · Eduardo Kenji Suzuki · Marcelo dos Santos Rodrigues · Marcio Luis Velasco Guidolin · Darcymara Alves de Morais · Fernanda Goyo Tamanaka

### SI (Segurança da Informação) — Imperva, PCI, políticas de segurança
Alain Deberdt · Carlos Ailson Santos Costa Junior · **Enio Marcelo da Silva** · Diego Tajima de Sousa · Carlos Hirochi Taninaka · Henrique Fagundes Cruz · Shaeny Caroline Generoso · Giovanni Pereira Tavares · Larissa Andrade Dos Santos · Thiago Da Silva Santos · Henrique Da Paz Costa · Thaynara Duarte Custodio · Lais Gedraits E Silva · Eduardo Abreu Da Silva · Gustavo de Oliveira Noe Nalin Fernandes · Nayara de Miranda Rita · Caue Da Silva Rodrigues · Milton Barboza dos Santos · Elizandra Silva Barbosa · Pablo Ewerton Da Silva Campos · Rodrigo Mascarenhas Iamasaki · Michel de Brito Lopes

### Network — CIDR, DNS, rotas, firewall
Diego Barbosa · Cicero Aranha · Thiago Silva · Thiago Faustino · Marcio Maria · Ewerton Gressi · **Diogo Patrício** · Jackson Silva

### Infra / SRE / Produção
**Infra:** Thiago Ezsias Roberto
**SRE** (ambiente, aprovação de rollback): Erik Martos · Alfredo Neto · Renato Barone · Leonardo Bastos
**Produção** (aprovação de deploy PRD): André Pereira · Felipe Machado · Renan Alves Barbosa Da Silva · Silas de Lima Borges · William dos Santos · Jonathan Xavier · Elvis Ribeiro · Weslley Queiroz

### Servidores
Guilherme Abreu La Torraca
**Windows:** Ithallo Oliveira Nunes · Oswaldo Grimaldi Coutinho · João Macedo
**Linux:** Luciano de Arruda Balabem · Kleber Vieira de Araujo · Rafael Augusto de Brito Neves · Esau Silva

---

## 10. Padrões de nomenclatura de repositório

Validado automaticamente na criação do projeto — falha se não bater:

| Tecnologia | Prefixo | Tecnologia | Prefixo |
|---|---|---|---|
| Lambda | `NJS*` / `NTS*` | Python | `py*` |
| Java | `ms*` | Node | `nst*` / `nod*` |
| Tomcat | `tomcat*` | Golang | `go*` |
| Angular | `ang*` / `rjs*` | Testes automatizados | `automation*` |
| React MicroFrontend | `rnm*` | Ionic | `IONIC*` |

---

## Ver também

- [[Esteira AWS - mecanica das pipelines (Lambda, SQS-Dynamo, Terraform)]] — mecânica técnica das pipelines
- [[2026-07-02_chatbot-gringo-zendesk-agentcore]] — projeto que motivou o levantamento
- [[30-06-2026]] — incidente das Lambdas na VPC errada
