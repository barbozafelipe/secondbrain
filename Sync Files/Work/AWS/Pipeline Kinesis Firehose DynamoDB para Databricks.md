Chamado: CTASK0133209

![[Pasted image 20260504175636.png]]

***Chamar o Victor Pereira Cesar para acompanhar a execução

Pré-requisitos
  Acesso à conta STP PRD
  Permissão para:
  Kinesis
  DynamoDB
  Firehose
  S3
  IAM

Passo a Passo (Console AWS)

   1. Acessar ambiente
      Acessar o console da Amazon Web Services
      Selecionar a conta STP PRD
      Validar região correta (ex: sa-east-1)

   2. Criar Kinesis Data Stream

      No menu de serviços, buscar por Kinesis
      Clicar em Kinesis Data Streams
      Clicar em Create data stream
      Preencher:
      
         Name: app-vehicles-stream (ou padrão do projeto)
         Capacity mode:
         Preferencial: On-demand (evita dor de cabeça com shard)
         Encryption: Enabled (KMS default ou custom)
         Clicar em Create data stream
        Validar se o status ficou Active

   3. Configurar DynamoDB Streams

       Acessar DynamoDB
       Ir em Tables
       Selecionar tabela: APP-Vehicles
       Aba Exports and streams
       Em DynamoDB stream details, clicar em Turn on
       Configurar:
       
          View type: New and old images
          Salvar

   4. Criar integração (Lambda → Kinesis)

   (Se não existir ainda — provável cenário)

       Acessar Lambda
       Clicar em Create function
       Nome: app-vehicles-ddb-to-kinesis
       Runtime: Node.js (ou padrão do projeto)
       Adicionar trigger:

          Add trigger → DynamoDB
          Selecionar tabela: APP-Vehicles
          Habilitar trigger

       Configurar envio para Kinesis:

          No código da Lambda, garantir que:
             Captura eventos do stream
             Envia para o Kinesis criado
            (Se já existir Lambda padrão, apenas validar configuração)

   5. Configurar Firehose (se aplicável)

       Acessar Kinesis Data Firehose
       Selecionar delivery stream existente
       (ou criar novo se necessário)
       Editar destino:

          Bucket S3 correto (Databricks)
          Prefixo/pasta conforme padrão
          Salvar

   6. Validar fluxo ponta a ponta

       Inserir ou alterar registro na tabela APP-Vehicles
       Validar:
       DynamoDB Stream gerou evento
       Lambda executou (CloudWatch Logs)
       Kinesis recebeu evento
       S3 recebeu arquivo (via Firehose)
      Databricks consumindo

**Os Passos para alcançar o objetivo podem ser revistos durante a execução da tarefa por ser uma execução manual com acompanhamento do Time de Dados.

EXECUÇÃO:  
 

1. Criei o Data stream (app-vehicles-stream), serviço responsável por monitorar ao vivo a entrada de dados de uma tabela no Dynamo DB
2. Para que o Data stream pudesse monitorar a entrada de dados na tabela (APP_Vehicles) do Dynamo DB, eu precisei ir até a tabela em "Exports and streams" e ligar o "Amazon Kinesis data stream details", ao ligá-lo eu o associo ao Data stream que eu criei anteriormente (app-vehicles-stream) para que ele tenha a permissão de monitorar a entrada de dados naquela tabela.
3. A criação de um lambda não foi necessária, pois por padrão já é utilizado um lambda existente neste processo
4. Foi necessário criar um novo Firehose stream, onde configurei que o source dele seria o Data stream que eu havia criado (app-vehicles-stream), o Data transformation (tive que habilitá-lo) seria o lambda padrão (lambda-transformation-dla) e o destino seria um S3 presente em outra conta (tive que criar apontando para um S3 chamado "bucket-integration-temp-prod" para apenas criar este Firehose streams, já que a bucket que eu precisava apontar não aparece na criação manual. Após criar manualmente, foi necessário utilizar o seguinte script via CLI da AWS:  
     

`aws firehose update-destination --region sa-east-1 \`
  `--delivery-stream-name DNA_Vehicles \`
  `--current-delivery-stream-version-id 2 \`
  `--destination-id destinationId-000000000001 \`
  `--extended-s3-destination-update '{`
    `"RoleARN": "arn:aws:iam::867102406853:role/firehose-role-v10",`
    `"BucketARN": "arn:aws:s3:::flt-dna-l0-landing-284309077449-sp5",`
    `"Prefix": "Seguros/InsurTech/",`
    `"BufferingHints": {`
      `"SizeInMBs": 5,`
      `"IntervalInSeconds": 300`
    `},`
    `"CompressionFormat": "UNCOMPRESSED"`
  `}'`


Executar o comando acima via git bash

[https://fleetcor-my.sharepoint.com/personal/felipe_goncalves_corpay_com_br/Documents/Felipe%20@%20Corpay%20-%20Linked%20Files/Chamada%20com%20Thiago%20e%201%20outra%20pessoa-20260415_163632-Gravação%20de%20Reunião.mp4](https://fleetcor-my.sharepoint.com/personal/felipe_goncalves_corpay_com_br/Documents/Felipe%20@%20Corpay%20-%20Linked%20Files/Chamada%20com%20Thiago%20e%201%20outra%20pessoa-20260415_163632-Gravação%20de%20Reunião.mp4)