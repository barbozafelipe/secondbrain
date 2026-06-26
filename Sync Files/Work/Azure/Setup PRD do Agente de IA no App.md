
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

As variáveis abaixo devem ser incluídas em nosso recurso:

VARIAVEIS:

`ApplicationInsightsAgent_EXTENSION_VERSION = disabled`

 `AZURE_OPENAI_API_KEY = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

 `AZURE_OPENAI_API_VERSION = 2025-08-28`

 `AZURE_OPENAI_AUDIO_DEPLOYMENT = gpt-4o-mini-transcribe`

 `AZURE_OPENAI_CHAT_DEPLOYMENT = gpt-4.1-nano`

 `AZURE_OPENAI_EMBEDDING_DEPLOYMENT = text-embedding-3-large`

 `AZURE_OPENAI_ENDPOINT = [https://stp-dig-cog-aiagentapp-prd.openai.azure.com/](https://stp-dig-cog-aiagentapp-prd.openai.azure.com/)`

 `AZURE_OPENAI_REALTIME_DEPLOYMENT = gpt-realtime-mini`

 `AZURE_SEARCH_API_KEY = [https://stp-dig-cog-aiagentapp-prd.openai.azure.com/](https://stp-dig-cog-aiagentapp-prd.openai.azure.com/)`

 `AZURE_SEARCH_ENDPOINT = [https://stp-dig-srch-aiagentsapp-prd.search.windows.net](https://stp-dig-srch-aiagentsapp-prd.search.windows.net)`

 `AZURE_SEARCH_INDEX_NAME = aiapp`

 `COSMOS_CONTAINER_CONVERSA = conversa`

 `COSMOS_CONTAINER_MENSAGEM = mensagem`

 `COSMOS_CONTAINER_RELACAO_SUPLEMENTAR = relacao-suplementar`

 `COSMOS_CONTAINER_USUARIO = usuario`

 `COSMOS_CONVERSA_PK = /session_id`

 `COSMOS_DATABASE = COSMOS_DATABASE`

 `COSMOS_ENDPOINT = [https://stp-dig-cdb-aihub-nprd.documents.azure.com:443/](https://stp-dig-cdb-aihub-nprd.documents.azure.com:443/)`

 `COSMOS_KEY = < obter no recurso >`

 `COSMOS_MENSAGEM_PK = /id`

 `COSMOS_RELACAO_SUPLEMENTAR_PK = /nome_evento_tarifario_cgmp`

 `COSMOS_USUARIO_PK = /cpf`

 `DEBUG = true`

 `EMBEDDINGS_PROVIDER = foundry`

 `ENABLE_ORYX_BUILD = false`

 `FOUNDRY_API_KEY = xxxxxxxxxxxxxxx

 `FOUNDRY_EMBEDDINGS_URL = [https://stp-dig-cog-aiagentapp-prd.openai.azure.com/openai/deployments/text-embedding-3-large/embeddings?api-version=2023-05-15](https://stp-dig-cog-aiagentapp-prd.openai.azure.com/openai/deployments/text-embedding-3-large/embeddings?api-version=2023-05-15)`

 `JWT_SECRET =eyJhbGciOiJIUzUx54354534543rcwfscf32r2r12414124cfcfaGFyYXIgaWEgY2hhdCBhY2Nlc3MgdG9rZW4ifQ.FRVxz7wZ1oUfXm-Z5oW5X7ZzmxMBDOxuwHxDrmpQ_3dPLI0uCz10FnZCos8kyxXj5hd-02A037U2IvO46fVoCw`

 `LANGFUSE_BASE_URL = [https://cloud.langfuse.com](https://cloud.langfuse.com)`

 `LANGFUSE_FLUSH_AT = 20`

 `LANGFUSE_FLUSH_INTERVAL = 10000`

 `LANGFUSE_PUBLIC_KEY = pk-lf-cc9ea487-6324-4847-bece-337cd7fadd03 LANGFUSE_SECRET_KEY = sk-lf-84655178-9485-4d74-a838-16ea14ccc4c5`

 `LANGUAGE = pt-BR`

 `NODE_ENV = production`

 `OPENAI_API_EMBEDDING_URL = [https://stp-dig-cog-aiagentapp-prd.openai.azure.com/openai/deployments/text-embedding-3-large/embeddings?api-version=2023-05-15](https://stp-dig-cog-aiagentapp-prd.openai.azure.com/openai/deployments/text-embedding-3-large/embeddings?api-version=2023-05-15)`

 `OPENAI_API_KEY = CNhPkWe6QVHEQrA5255235234csfsxxfsgfhBlr8NnIJQQJ99CCACHYHv6XJ3w3AAABACOGkhPt`

 `OPENAI_API_URL = [https://stp-dig-cog-aiagentapp-prd.openai.azure.com/](https://stp-dig-cog-aiagentapp-prd.openai.azure.com/)`

 `PORT = 3001`

 `REDIS_PASSWORD = sAwZdbSGqM7Q234234fcsdfscsdfaJfUCAzCaIzf4T4=`

 `REDIS_URL = stp-dig-redis-aiagentsapp-prd.brazilsouth.redis.azure.net:10000`

 `SCM_COMMAND_IDLE_TIMEOUT = 1800`

 `SCM_DO_BUILD_DURING_DEPLOYMENT = false`

 `SEMPARAR_API_BASE_URL = [www.apisemparar.io/ai/integrations](http://www.apisemparar.io/ai/integrations)`

 `SEMPARAR_API_KEY = wzREKwsPY5423453214cxvxcvwsdvQFSkY4xK66mHZwVRT`

 `SEMPARAR_CA_CERT = -----BEGIN CERTIFICATE-----xxxxxxxxxxxxxxxxxxxxxxxxxxxx-----END CERTIFICATE-----`

 `SEMPARAR_CLIENT_CERT = -----BEGIN CERTIFICATE-----xxxxxxxxxxxxxxxxxxxxxxxxxxxxx//n-----END CERTIFICATE-----`

 `SEMPARAR_CLIENT_KEY = -----BEGIN PRIVATE KEY-----//xxxxxxxxxxxxxxxxxxxxxx//n-----END PRIVATE KEY-----`

 `SEMPARAR_DB = postgresql://loomi:loomi@localhost:5432/loomi`

 `STAGING_API_KEY = 1dee234234523423432423432423423423423

 `WEBSITE_HTTPLOGGING_RETENTION_DAYS = 3`

 `XDT_MicrosoftApplicationInsights_NodeJS = 0`

Caso necessário, entrar em contato com a equipe de desenvolvimento do produto para editar as variáveis de ambiente manualmente no recurso.


### CTASK0132399
Configurar a API do IA NO APP no API Management (APIM) apontando para o endpoint produtivo do Azure Web APP, ajustar a rota de produção e validar que as requisições estão sendo corretamente direcionadas ao Web APP.

Link para o recurso na Azure: [https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.ApiManagement/service/stp-dig-apim-aiagentsapp-prd/overview](https://portal.azure.com/#@fleetcorbr.onmicrosoft.com/resource/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-aiagentsapp-prd/providers/Microsoft.ApiManagement/service/stp-dig-apim-aiagentsapp-prd/overview)