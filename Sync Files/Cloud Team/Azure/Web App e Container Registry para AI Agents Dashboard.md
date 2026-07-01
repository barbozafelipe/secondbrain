---
tags: [task, azure, infra, webapp, container-registry]
status: em andamento
criado: 2026-05-11
---

Chamado: TASK1247602

# TASK1247602 — Web App + Container Registry para AI Agents Dashboard

---

## 📋 Descrição Original

> O projeto de internalização do IA no App trouxe um novo requisito que é a internalização de um dashboard criado pelo fornecedor e utilizado pelo time de produtos. Para isso, precisamos de um novo Web App com service plan separado e um container registry para cada resource group relacionado ao projeto.

### Subscription DIGITAL-NPROD
1. No RG `stp-dig-rg-aiagentsapp-nprd`, precisamos provisionar os seguintes recursos:
   - 1.1. WebApp com service plan separado: `stp-dig-app-aiagentsdash-nprd` — Plano TIER B1
   - 1.2. Container Registry: `stpdigacraiagentsdashnprd`

2. No RG `stp-dig-rg-aiagentsapp-hml-nprd`, precisamos provisionar os seguintes recursos:
   - 2.1. WebApp com service plan separado: `stp-dig-app-aiagentsdash-hml-nprd` — Plano TIER B1
   - 2.2. Container Registry: `stpdigacraiagentsdashhmlnprd`

### Subscription DIGITAL-PROD
3. No RG `stp-dig-rg-aiagentsapp-prd`, precisamos provisionar os seguintes recursos:
   - 3.1. WebApp com service plan separado: `stp-dig-app-aiagentsdash-prd` — Plano TIER B1
   - 3.2. Container Registry: `stpdigacraiagentsdashprd`

> Estamos solicitando o provisionamento NPROD e PROD no mesmo chamado, pois precisamos liberar a solução internalizada o quanto antes para ser integrada ao App.
> A necessidade de um novo Service Plan para cada WebApp ocorre para disponibilizar a solução exclusivamente interna com acesso via VPN.

---

## 🧠 Entendendo a Task

> *Antes de executar, entenda. O cérebro retém melhor quando conecta o novo ao que já conhece.*

### Por que essa task existe?

Um fornecedor externo criou um dashboard para o time de produtos. A empresa quer **internalizar** esse dashboard — ou seja, tirá-lo do ambiente do fornecedor e hospedá-lo dentro da própria infraestrutura Azure. Para isso, precisam de infraestrutura nova.

### O que você vai provisionar, exatamente?

Pense em **3 ambientes** e, para cada um, **2 recursos**:

| Ambiente | Resource Group | Web App | Container Registry |
|---|---|---|---|
| NPRD (dev/test) | `stp-dig-rg-aiagentsapp-nprd` | `stp-dig-app-aiagentsdash-nprd` | `stpdigacraiagentsdashnprd` |
| HML (homologação) | `stp-dig-rg-aiagentsapp-hml-nprd` | `stp-dig-app-aiagentsdash-hml-nprd` | `stpdigacraiagentsdashhmlnprd` |
| PRD (produção) | `stp-dig-rg-aiagentsapp-prd` | `stp-dig-app-aiagentsdash-prd` | `stpdigacraiagentsdashprd` |

> 💡 **Ancora mental:** É sempre o mesmo padrão. Cada ambiente = 1 Web App + 1 Container Registry. Você vai repetir o mesmo processo 3 vezes, apenas trocando os nomes e a subscription.

### Por que um Service Plan separado?

O acesso ao dashboard será **exclusivamente interno via VPN**. Um Service Plan dedicado garante que esse Web App não compartilhe recursos com outras aplicações e permite controle de rede isolado. Isso é uma decisão de segurança e isolamento.

### Por que NPROD e PROD no mesmo chamado?

Urgência. O time precisa que a solução seja integrada ao App o mais rápido possível. Quebrar em dois chamados criaria delay desnecessário no processo de aprovação.

### Perguntas-guia para não errar

- [x] Os nomes dos recursos estão exatamente conforme solicitado? (sem espaços, sem maiúsculas erradas)
- [x] O Tier do Service Plan está como **B1** nos 3 ambientes?
- [x] Cada Web App tem seu próprio Service Plan (não compartilhado)?
- [x] NPROD e HML estão na subscription `DIGITAL-NPROD` e PRD na `DIGITAL-PROD`?
- [x] O Container Registry de cada ambiente está no RG correto?

---

## 📝 Minhas Anotações

> Claro. Você pode colar esse bloco direto em **Minhas anotações** no Obsidian:

````markdown
## Minhas anotações — Provisionamento WebApp Dashboard IA Agents via Terraform

Nesta task foi necessário provisionar recursos novos para o dashboard do projeto **AI Agents App** nos ambientes **HML/NPROD** e **PROD**, usando o repositório Terraform já existente da empresa.

A solicitação original pedia a criação de:

- WebApp para o dashboard;
- App Service Plan separado, com tier **B1**;
- Container Registry para o dashboard.

A principal atenção nesta task foi não recriar ou alterar recursos que já existiam no Azure. O RG já possuía vários recursos criados e gerenciados pelo Terraform, então antes de aplicar qualquer mudança foi necessário entender a estrutura dos arquivos `.tf` existentes e validar o `terraform plan`.

---

## Como o Terraform estava organizado

Cada Resource Group tem sua própria pasta no repositório, por exemplo:

- `DIGITAL-NPROD/stp-dig-rg-aiagentsapp-hml-nprd`
- `DIGITAL-PROD/stp-dig-rg-aiagentsapp-prd`

Dentro de cada pasta existem arquivos como:

- `provider.tf`
- `resource_group.tf`
- `data.tf`
- `app_service.tf`
- `containerregistry.tf`
- `storage_account.tf`
- `openai.tf`
- outros recursos dependendo do ambiente

O Terraform lê todos os arquivos `.tf` da pasta como se fossem um conjunto único. Então não importa muito se o recurso está no `app_service.tf`, `webapp_dash.tf` ou `containerregistry.tf`, desde que os blocos estejam corretos e apontando para os módulos e variáveis certas.

O Resource Group é criado/gerenciado via módulo:

```hcl
module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "nome-do-rg"
  location            = "brazilsouth"
}
````

Os demais recursos usam:

```hcl
module.rg.resource_group_name
module.rg.resource_group_location
```

Isso evita digitar o nome do RG e a localização repetidamente em cada recurso.

---

## O que foi feito em HML/NPROD

RG:

```text
stp-dig-rg-aiagentsapp-hml-nprd
```

Subscription:

```text
DIGITAL-NPROD
36df8ac5-dab6-4301-9cbf-97aa398ba021
```

Recursos envolvidos:

```text
WebApp novo:
stp-dig-app-aiagentsdash-hml-nprd

App Service Plan novo:
stp-dig-asp-aiagentsdash-hml-nprd

Tier:
B1

ACR existente:
stpdigacraiagentshmlnprd
```

Inicialmente a solicitação mencionava um ACR com `dash` no nome:

```text
stpdigacraiagentsdashhmlnprd
```

Porém foi confirmado internamente que o ACR já existente, criado pelo colega, seria usado para essa task:

```text
stpdigacraiagentshmlnprd
```

Ou seja, no HML não foi necessário criar um novo ACR. O ACR existente já aparecia no `terraform plan` como recurso em refresh do state:

```text
module.acr.azurerm_container_registry.acr
```

Isso indicou que o Terraform já conhecia o recurso e não tentaria recriá-lo.

Foi criado um novo arquivo/bloco para o dashboard:

```text
webapp_dash.tf
```

O ponto importante foi configurar:

```hcl
create_app_service_plan = true
service_plan_name       = "stp-dig-asp-aiagentsdash-hml-nprd"
sku_name                = "B1"
app_name                = "stp-dig-app-aiagentsdash-hml-nprd"
```

Depois do ajuste, o `terraform plan` mostrou:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

Os recursos criados foram somente:

```text
module.web_app_dash.azurerm_service_plan.asp[0]
module.web_app_dash.azurerm_linux_web_app.app
```

Depois do `terraform apply`, validei no Portal Azure que os recursos apareceram no RG:

```text
stp-dig-app-aiagentsdash-hml-nprd
Tipo: App Service
Kind: app,linux,container

stp-dig-asp-aiagentsdash-hml-nprd
Tipo: App Service plan
Kind: linux
```

---

## O que foi feito em PROD

RG:

```text
stp-dig-rg-aiagentsapp-prd
```

Subscription:

```text
DIGITAL-PROD
b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058
```

Recursos envolvidos:

```text
WebApp novo:
stp-dig-app-aiagentsdash-prd

App Service Plan novo:
stp-dig-app-aiagentsdash-prd

Tier:
B1

ACR existente:
stpdigacraiagentsprd
```

No PROD, o nome do App Service Plan foi mantido igual ao nome do WebApp por decisão do padrão/execução usada na task:

```text
stp-dig-app-aiagentsdash-prd
```

Embora normalmente eu prefira usar `asp` no nome do App Service Plan, nesta execução foi validado que o nome igual ao WebApp era intencional.

O `terraform plan` de PROD mostrou:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

Ou seja, seriam criados somente:

```text
module.web_app_dash.azurerm_linux_web_app.app
module.web_app_dash.azurerm_service_plan.asp[0]
```

O plan confirmou:

```text
WebApp:
stp-dig-app-aiagentsdash-prd

App Service Plan:
stp-dig-app-aiagentsdash-prd

SKU:
B1

Location:
brazilsouth

RG:
stp-dig-rg-aiagentsapp-prd
```

Também foi validado que não haveria alteração nem destruição de recursos existentes, como:

```text
stp-dig-app-aiagentsapp-prd
stp-dig-asp-aiagentsapp-02-prd
stpdigacraiagentsprd
stpdigaiagentsprd
stp-dig-cog-aiagentapp-prd
stp-dig-apim-aiagentsapp-prd
stp-dig-cdb-aiagentsapp-prd
stp-dig-redis-aiagentsapp-prd
stp-dig-srch-aiagentsapp-prd
```

---

## Comandos usados

Dentro da pasta do respectivo RG:

```powershell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Antes de aplicar, sempre validei se o plano estava seguro:

```text
0 to change
0 to destroy
```

O apply só foi feito quando o Terraform mostrou apenas os recursos novos esperados.

---

## Ponto de atenção importante

Quando um recurso já existe no Azure, isso não significa automaticamente que ele está gerenciado pelo Terraform.

Para saber se o Terraform já conhece o recurso, é possível usar:

```powershell
terraform state list
```

Ou observar no `terraform plan` se o recurso aparece como:

```text
Refreshing state...
```

Exemplo:

```text
module.acr.azurerm_container_registry.acr: Refreshing state...
```

Isso indica que o recurso já está no state.

Se um recurso existe no Azure, mas não está no state, o Terraform pode tentar criá-lo novamente e falhar com erro de recurso já existente. Nesse caso, o correto seria importar o recurso para o state antes de aplicar.

---

## Critério que usei para decidir se podia aplicar

Antes de dar `apply`, conferi:

1. Se a subscription estava correta.
    
2. Se o RG estava correto.
    
3. Se o WebApp novo tinha o nome esperado.
    
4. Se o App Service Plan estava em **B1**.
    
5. Se a location estava em **Brazil South / brazilsouth**.
    
6. Se o plano não iria alterar recursos existentes.
    
7. Se o plano não iria destruir nada.
    
8. Se o ACR já existente estava no state ou se não precisava ser criado.
    

O cenário seguro era:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

ou, caso fosse criar ACR novo também:

```text
Plan: 3 to add, 0 to change, 0 to destroy.
```

Nesta task, no fim, o fluxo aplicado foi de criação apenas do WebApp e do Service Plan, pois o ACR já existia/foi considerado já atendido.

---

## Como funciona esse tipo de task aqui

Para esse tipo de demanda de provisionamento Azure via Terraform, o ideal é:

1. Entrar na pasta do RG correto no repositório.
    
2. Conferir o `provider.tf` para garantir que está apontando para a subscription correta.
    
3. Conferir o `resource_group.tf` para garantir que o RG e a location estão corretos.
    
4. Conferir se já existe um recurso parecido no Portal Azure.
    
5. Criar um arquivo separado para o recurso novo quando fizer sentido, por exemplo `webapp_dash.tf`.
    
6. Reaproveitar os módulos existentes da empresa, como:
    
    - `../../MODULES/app_service_linux`
        
    - `../../MODULES/container_registry`
        
    - `../../MODULES/resource_groups`
        
7. Rodar `terraform plan`.
    
8. Só aplicar se o plan estiver limpo e sem impacto em recursos existentes.
    

Neste caso, o módulo usado para o WebApp foi:

```hcl
source = "../../MODULES/app_service_linux"
```

E o módulo criou tanto o App Service Plan quanto o Linux Web App quando configurado com:

```hcl
create_app_service_plan = true
```

O tier B1 foi definido com:

```hcl
sku_name = "B1"
```

A subnet de integração do WebApp foi buscada via `data.tf`:

```hcl
data.azurerm_subnet.snet_app.id
```

Isso apontou o WebApp para a subnet de app da VNet do ambiente.

---

## Resultado final

A task foi concluída com sucesso.

Foram provisionados os WebApps de dashboard e seus respectivos App Service Plans separados nos ambientes necessários, sem alterar ou destruir recursos já existentes.

Resumo:

```text
HML/NPROD:
WebApp criado: stp-dig-app-aiagentsdash-hml-nprd
App Service Plan criado: stp-dig-asp-aiagentsdash-hml-nprd
SKU: B1
ACR utilizado: stpdigacraiagentshmlnprd

PROD:
WebApp criado: stp-dig-app-aiagentsdash-prd
App Service Plan criado: stp-dig-app-aiagentsdash-prd
SKU: B1
ACR utilizado: stpdigacraiagentsprd
```

Aprendizado principal: antes de criar qualquer coisa via Terraform, validar no Portal e no state se o recurso já existe. O `terraform plan` é a principal proteção antes do apply. Nesta task, só apliquei quando o plano mostrou criação apenas dos recursos esperados e nenhum `change` ou `destroy`.

---
