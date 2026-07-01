
Descrição:

Chamado: CHG0094480

==Solicitação do Negócio ou Motivo da Mudança: Solicitação do time de negócios para a integração do IA NO APP no ambiente da Azure com rota dedicada a uso de IA conversacional.==
==Qual objetivo da mudança? Atender solicitação do time de negócios para integração do IA no APP com rota dedicada a uso de IA conversacional.==
==No processo de aplicação em Produção:==
==a. Quais são as tecnologias envolvidas (BPEL, BUS, JSF, MS etc.) e seus componentes?  Azure Web APP, APIM, Azure AI Search (Azure), Azure OpenAI, Azure Cosmos DB.==
==b. Quantos scripts de banco estão previstos? Nenhum.==
==Algum componente é utilizado por outra aplicação? Não, nenhuma outra ferramenta utiliza o serviço no momento, esta é uma change de Setup de Ambiente==



### CTASK0132395
Criar os seguintes modelos de IA:

- gpt-realtime-mini
- text-embedding-3-large
- gpt-4.1-nano
- gpt-4o-mini-transcribe
- text-embedding-ada-002

No seguinte recurso: [https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.CognitiveServices/accounts/stp-dig-cog-aiagentapp-prd/overview](https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.CognitiveServices/accounts/stp-dig-cog-aiagentapp-prd/overview)

Entrar em contato com a equipe do Go AI para realizar a aplicação.

EXECUÇÃO:
![[Pasted image 20260504193305.png]]


### CTASK0132396
Devemos criar o Database: COSMOS_DATABASE
Devemos criar os seguintes Containeres dentro do Database COSMOS_DATABASE:

    conversa (PK: /session_id),
    mensagem (PK: /id),
    relacao-suplementar (PK: /nome_evento_tarifario_cgmp),
    usuario (PK: /cpf)

EXECUÇÃO:
![[Pasted image 20260504193400.png]]
![[Pasted image 20260504193407.png]]
![[Pasted image 20260504193413.png]]


### CTASK0132397
O recurso que deve receber as novas variáveis é: [https://portal.azure.com/#resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.Web/sites/stp-dig-app-aiagentsapp-prd](https://portal.azure.com/#resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.Web/sites/stp-dig-app-aiagentsapp-prd)

As variáveis abaixo devem ser incluídas em nosso recurso.
Caso necessário, entrar em contato com a equipe de desenvolvimento do produto para editar as variáveis de ambiente manualmente no recurso.


### CTASK0132399
Configurar a API do IA NO APP no API Management (APIM) apontando para o endpoint produtivo do Azure Web APP, ajustar a rota de produção e validar que as requisições estão sendo corretamente direcionadas ao Web APP.

Link para o recurso na Azure: [https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.ApiManagement/service/stp-dig-apim-aiagentsapp-prd/overview](https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.ApiManagement/service/stp-dig-apim-aiagentsapp-prd/overview)