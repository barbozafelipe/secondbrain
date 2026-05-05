---
tags: [trabalho, gringo, gcp, terraform, iac, reunião-técnica]
tipo: reunião técnica
---

# IaC com Terraform na GCP — Gringo

> [!info] Contexto
> Reunião técnica sobre o estado atual do Terraform no ambiente **Gringo (GCP)**. Conduzida pelo Wellington com participação do time de Cloud (João Pedro, Messias, Thiago, Léo, Matheus) e de uma pessoa do lado da Gringo (DevOps/IaC). Objetivo: entender como o IaC está estruturado, identificar problemas de governança e planejar melhorias.

---

## ⚡ TL;DR — o que mais importa desta reunião

1. **O Terraform da Gringo está em um único repo monolítico** — um `plan` varre o ambiente inteiro, qualquer problema em um recurso trava tudo.
2. **Hoje, apenas uma pessoa aprova mudanças de infra** — o time de Cloud fica no escuro sobre o que sobe em produção.
3. **A service account do Terraform tem permissões quase-admin e a chave nunca foi rotacionada** — risco de segurança crítico. João ficou responsável por rotacionar.
4. **Há 1.800+ secrets em produção** — Messias está mapeando o que está ativo. Algumas secrets de staging espelham valores de produção.
5. **Plano imediato**: criar canal de solicitações de infra + bloquear merge no repo de IaC sem aprovação do time de Cloud.

---

## 👤 O que me diz respeito diretamente

> [!warning] Acesso ao repositório de infra da Gringo ainda pendente
> Parte do time ainda não tem acesso ao repo de Terraform da Gringo no GitHub. O desbloqueio depende do Zaza. Wellington ficou de cobrar. **Verificar se seu acesso foi concedido.**

> [!tip] O time de Cloud vai passar a aprovar mudanças de IaC
> A partir do alinhamento desta reunião, qualquer mudança de infraestrutura na Gringo precisa passar pelo time de Cloud antes de ir para produção. João Pedro e Messias são os pontos focais no primeiro momento, mas o contexto é relevante para todos.

---

## 🗂️ Estado atual do Terraform na Gringo

### Estrutura do repositório
- **1 repositório** para os dois ambientes: `staging` e `produção`
- Dentro de cada ambiente, os recursos são organizados **por serviço** — cada serviço tem um arquivo com tudo que ele usa: bucket, Pub/Sub, banco de dados, etc.
- Quando roda o `terraform plan`, ele **escaneia o ambiente inteiro** — não tem separação por módulo ou serviço

**Problema direto**: mexer em um banco de dados faz o plan considerar tópicos Pub/Sub, buckets e tudo mais. Se algum recurso está divergente (foi alterado na mão, ou tem algo órfão), **trava tudo**.

### Quem pode fazer o quê

| Ator | Pode fazer |
|---|---|
| Devs da Gringo | Adicionar recursos seguindo módulos existentes (Pub/Sub, Cloud SQL, Scheduler, Secrets...) |
| DevOps/IaC Gringo | Roda o `plan`, valida, aprova e aplica — é o único aprovador hoje |
| Time de Cloud (Sem Parar) | **Ainda não tem visibilidade nem aprovação** — isso vai mudar |
| Time de dados (Rodolfo/Sávio) | Usam Cloud Build, são um "mundo à parte" com orçamento separado |

### Pipelines de CI/CD
- Aplicações de infra: **GitHub Actions** (migrado do Cloud Build)
- Dados: ainda via **Cloud Build** — não é responsabilidade do time de Cloud por ora
- O pipeline valida a branch: se é PR → roda só o `plan`; se é push → vai até o `apply`

---

## 🔐 Problemas de Segurança — Prioridade Alta

> [!danger] Service Account do Terraform: quase-admin, chave nunca rotacionada
> - A SA do Terraform é salva como secret no GitHub e usada pelos runners temporariamente
> - Tem permissões próximas de admin no projeto GCP
> - Provavelmente existem duas: uma para prod e uma para staging
> - **Ação imediata**: João Pedro vai rotacionar a chave e restringir quem tem acesso à secret no GitHub

> [!danger] Secrets de staging espelhando valores de produção
> - Devs da Gringo conseguem **criar** secrets em prod, mas não conseguem **ver o valor**
> - Tech leads têm acesso de leitura e escrita nos valores (usam muito para Pix e parceiros)
> - Em staging, o acesso é mais aberto — e tem secrets com os **mesmos valores de produção**
> - Isso é um vetor de vazamento real. Messias está mapeando (1.800+ secrets em prod)

> [!warning] Kong sem autenticação
> - Interface administrativa do Kong acessível em `http://<IP_do_kong>:8002` dentro da VPN
> - Sem nenhuma autenticação configurada
> - Wellington quer manter visibilidade temporária e depois desligar

---

## 🛠️ Decisões e Planos

### Governança de IaC — curto prazo

1. **Criar um canal** (Teams/Slack) para devs da Gringo fazerem solicitações de infra
2. **Bloquear merge** no repositório de Terraform sem aprovação do time de Cloud
3. Eventualmente: formalizar mudanças de prod como **Change** no sistema de chamados

### Terraform — reestruturação

> [!tip] Não hidrate o repo atual — crie um novo
> Recomendação da própria pessoa da Gringo: o repo atual é tão acoplado que vale mais a pena **começar um repositório novo** para as coisas novas (ex: GKE Standard de staging) do que tentar organizar o que existe.

**Direção futura**:
- Separar em **múltiplos repositórios por tipo de recurso**: IAM, Pub/Sub, provisioning, rede, etc.
- Staging e produção com **módulos independentes** (hoje usam o mesmo módulo com variáveis — uma mudança afeta os dois)
- **Yasu** (nova no DevOps da Gringo) vai liderar essa reestruturação

### GKE Standard — staging via Terraform
- Wellington vai compartilhar o **documento de arquitetura** com CIDRs e subnets já planejados
- O CIDR foi solicitado ao time de networking para não conflitar com PSC e outras redes
- Objetivo: subir toda a estrutura — VPC, subnets, cluster GKE, DNS — **via Terraform**
- Trabalho conjunto: Wellington + pessoa da Gringo, "a quatro mãos", em repo separado
- Prazo estimado: começar a pensar em subir staging **no meio da semana seguinte à reunião**

### Kong → substituição gradual

| Componente | Substituto planejado |
|---|---|
| Tráfego entrando no cluster | **Ingress** (padrão já usado na Zapay) |
| Chamadas para Cloud Functions | **GCP API Gateway** (ou Apigee se precisar de mais recursos) |

**O que o Kong faz hoje** (apenas roteamento, sem autenticação):
- Rota externa: `api-prd.gringo.com.br` — acesso de apps e web
- Rota interna: `api-prd-interno.gringo.com.br` — acesso só dentro da VPN/VPC, usado para testes
- Alguns serviços usam automação com OpenAPI para expor rotas via Kong

**Decisão**: não eliminar o Kong abruptamente — entender primeiro e substituir componente por componente. Se precisar usar Kong, colocar dentro do cluster com versionamento.

---

## 📌 Ações identificadas na reunião

| Ação | Responsável |
|---|---|
| Rotacionar chave da service account do Terraform | **João Pedro** |
| Verificar e restringir acesso à secret do Terraform no GitHub | João Pedro + DevOps Gringo |
| Criar canal para solicitações de infra da Gringo | Wellington + DevOps Gringo |
| Bloquear merge no repo de IaC sem aprovação do Cloud | DevOps Gringo + GitHub admin |
| Compartilhar documento de arquitetura do GKE Standard | **Wellington** → DevOps Gringo |
| Verificar situação da VPN com Ian | **Thiago** |
| Verificar acesso ao GitHub para membros sem permissão | Wellington → Zaza |
| Buscar gravações de passagem de conhecimento (PH + Daniel) | **Wellington** (OneDrive do Daniel) |
| Mapear secrets ativas vs. obsoletas em prod | **Messias** (em andamento) |

---

## 📌 Referências e acessos (Gringo)

| Recurso | Como acessar |
|---|---|
| **VPN da Gringo** | `vpn.gringo.com.br/admin` — credenciais no Secret Manager do projeto; QR Code do 2FA em bucket |
| **Kong (admin UI)** | `http://<IP_kong>:8002` — sem autenticação, acessível dentro da VPN |
| **Repo Terraform** | GitHub Infra — solicitar acesso via Zaza; pedir criação de grupo Cloud |

---

## 📌 Glossário técnico desta reunião

| Termo | O que é |
|---|---|
| **Terraform plan** | Comando que calcula o que vai mudar sem aplicar — usado para revisar antes do apply |
| **Terraform apply** | Executa as mudanças no ambiente real |
| **Service Account (SA)** | Identidade de serviço no GCP — usada pelo Terraform para criar/alterar recursos |
| **PSC** | Private Service Connect — conectividade privada entre serviços GCP sem expor à internet |
| **Kong** | API Gateway open-source usado pela Gringo para roteamento de tráfego |
| **Apigee** | API Gateway enterprise do Google — mais robusto e mais caro que o API Gateway padrão |
| **Cloud Build** | CI/CD nativo do GCP — usado pelo time de dados da Gringo |
| **Autopilot** | Modo gerenciado do GKE — sem acesso ao master, mais restrito e mais caro |
| **GKE Standard** | Modo tradicional do GKE — mais controle, mais barato, compatível com Karpenter/Spot |
| **Yasu** | Nova pessoa do time de DevOps da Gringo — vai liderar reestruturação do Terraform |
