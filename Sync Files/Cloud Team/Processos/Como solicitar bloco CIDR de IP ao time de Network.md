---
tags: [trabalho, sem-parar, aws, azure, network, cidr, ip, service-now, padrão]
data: 2026-07-02
---

# Como solicitar bloco de CIDR (IP) ao time de Network

> [!info] Contexto
> Sempre que o time de Cloud precisar criar um recurso que exige um bloco de endereçamento IP próprio — ex: uma **VPC nova na AWS**, uma **VNet no Azure**, uma rede na OCI, etc — **não podemos definir o CIDR por conta própria**. É preciso abrir um chamado para o time de **Network**, que registra a alocação no sistema deles e alinha com o time de **SI (Segurança da Informação)**. Isso evita overlap de faixas de IP com outras redes da empresa (ex: integrações on-premises, VPNs, outras VPCs/VNets já existentes).
>
> Confirmado com **Thiago Ribeiro da Silva** (time de Network) em 2026-07-02, via Teams.

---

## ⚡ TL;DR — o que importa

1. **Nunca definir/inventar um CIDR por conta própria** para um recurso novo (VPC, VNet, etc) — sempre solicitar ao time de Network antes.
2. Abrir o chamado pelo **catálogo "Network"** no portal ServiceNow da SemParar.
3. Dá pra pedir **múltiplos blocos em um único chamado** (ex: 3 blocos para 3 VPCs diferentes).
4. Contato de referência no time de Network: **Thiago Ribeiro da Silva**.

---

## 🗂️ Passo a passo

### 1. Acessar o catálogo

Abrir o item de catálogo **"Network"** no ServiceNow:

`https://semparar.service-now.com/now/nav/ui/classic/params/target/com.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3D550c2fb51bde5d1404190fe1f54bcb1c%26sysparm_link_parent%3D6acade77334072d0009c1bbb9d5c7b57%26sysparm_catalog%3D63e7bd881be19d5004190fe1f54bcb4e%26sysparm_catalog_view%3Dcatalog_IT%26sysparm_view%3Dcatalogs_default`

> [!tip] Como achar de novo se o link mudar
> Caso o link direto pare de funcionar, pedir para alguém do time de Network reenviar o link do catálogo "Network" — não é fácil de achar navegando pelo portal padrão.

### 2. Preencher o formulário

| Campo | O que preencher |
|---|---|
| **Nome** | Preenchido automaticamente com o solicitante logado |
| **Telefone** | Informar um telefone de contato |
| **Descrição resumida** | Ex: `Solicitação de bloco CIDR para VPC AWS - <nome do projeto>` |
| **Descrição** | Detalhar: quantos blocos são necessários, para quais ambientes (dev/qa/prd), tamanho estimado de cada bloco (ex: `/24`, `/23`), e o motivo/projeto |
| **Selecione o item desejado** | Escolher a nuvem de destino (ex: `AWS`). Se precisar de bloco para Azure/OCI e a opção não aparecer no dropdown, confirmar com o Network |
| **Centro de custo** | Pode deixar em branco / `-- Nenhum(a) --` — Thiago confirmou que **não tem problema** deixar assim |

### 3. Submeter

Ao enviar, o chamado cai automaticamente na fila do time de Network, que aloca o(s) bloco(s) e retorna com o CIDR aprovado.

---

## 🔑 Pontos de atenção

| Ponto | Detalhe |
|---|---|
| Por que não posso escolher o CIDR sozinho? | Risco de overlap com outras redes da empresa (on-premises, VPNs, outras VPCs/VNets). O time de Network mantém o registro central e alinha com SI |
| Posso pedir vários blocos de uma vez? | Sim — dá pra listar todos os blocos necessários (ex: 3 VPCs = 3 blocos) na mesma solicitação, descrevendo cada um na "Descrição" |
| Preciso saber o tamanho exato do bloco antes de abrir o chamado? | Ajuda estimar (ex: `/24` por ambiente), mas o Network pode orientar o dimensionamento se não tiver certeza |
| Isso vale só para AWS? | Não — vale para qualquer nuvem/serviço que exija alocação de endereçamento IP próprio (Azure VNet, OCI VCN, etc). Se a opção certa não estiver no dropdown "Selecione o item desejado", confirmar com o Network como abrir |

---

## 🔁 Caso real que motivou este processo

> [!warning] Ver também
> No projeto do [[2026-07-02_chatbot-gringo-zendesk-agentcore|Chatbot Gringo]], uma VPC (`vpc-chatbot-dev`) foi criada **sem passar por este processo**, usando um CIDR (`10.4.0.0/16`) escolhido "no chute". Isso gerou a necessidade de destruir e recriar a VPC depois, já usando um bloco aprovado pelo Network — retrabalho que este processo evita.

---

## 📌 Glossário

| Termo | O que é |
|---|---|
| **CIDR** | Notação que define uma faixa de endereços IP (ex: `10.4.0.0/16`) — usada para definir o range de uma VPC/VNet |
| **VPC** | Virtual Private Cloud — rede virtual isolada na AWS |
| **VNet** | Virtual Network — equivalente à VPC no Azure |
| **SI** | Segurança da Informação — time que o Network alinha antes de liberar um bloco, para evitar conflitos/riscos de rede |
| **Catálogo ServiceNow** | Item de catálogo usado para abrir solicitações padronizadas (aqui, o item "Network") |
