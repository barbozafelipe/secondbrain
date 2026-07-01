
Acessar console do elastic de produção https://kibana.prd.rke.corpay.com.br/ e na aba de "Dev Tools" executar os dois comandos abaixo:

Índice prd-integracaometa-payments
```json
PUT prd-integracaometa-payments/_mapping 
{
  "properties": {
    "sqPagamento": { "type": "keyword" }
  }
}
```

Índice prd-integracaometa-userevents/

```json
PUT prd-integracaometa-userevents/_mapping
{
  "properties": {
    "clientStatus": { "type": "keyword" }
  }
}
```

