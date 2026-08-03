---
tags: [oci, zscaler, tls, ssl, certificado, cli, sdk, runbook]
status: ativo
---

# Zscaler CA bundle para OCI CLI e SDK

> [!info] Quando usar
> Sempre que o **OCI CLI** ou o **SDK Python `oci`** falhar com `SSLException` / "missing certificates" ao rodar de dentro da **rede corporativa Corpay** (VPN ou rede interna). Não afeta código rodando fora dessa rede (ex.: dentro de uma Lambda AWS — ver [[Relatorio de custo diario multi-cloud via Lambda + Cost API + SES (padrao Wellington)]]).

## Causa

A rede Corpay usa **Zscaler** fazendo inspeção TLS (proxy man-in-the-middle corporativo). Toda conexão HTTPS que sai da rede recebe de volta um certificado **emitido pelo Zscaler**, não pelo destino real. O erro típico:

```json
{
  "message": "It looks like you are missing some additional certificates for operation...",
  "request_endpoint": "GET https://objectstorage.<regiao>.oraclecloud.com"
}
```

O certificado apresentado é assinado por `CN="Zscaler Intermediate Root CA (zscalertwo.net) (t)"`. Essa intermediária **não está instalada em nenhum store do Windows** (nem CurrentUser nem LocalMachine) e a folha não tem AIA (Authority Information Access), então nem o Windows nem o `certutil` conseguem montar a cadeia sozinhos — só a raiz `Zscaler Root CA` está confiável no store.

## Solução

O servidor (via Zscaler) **manda a cadeia completa** no handshake TLS quando consultado com `openssl s_client` — mesmo o .NET/Windows não expondo isso. Montar um CA bundle combinando o `certifi` padrão do Python + essa cadeia capturada:

```bash
BUNDLE="$HOME/.oci/corpay-ca-bundle.pem"
CERTIFI=$(python -c "import certifi;print(certifi.where())")
cp "$CERTIFI" "$BUNDLE"
echo | openssl s_client -connect <endpoint>:443 -servername <endpoint> -showcerts 2>/dev/null \
  | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' >> "$BUNDLE"
```

Troque `<endpoint>` pelo host que está falhando (ex.: `objectstorage.sa-vinhedo-1.oraclecloud.com`, `usageapi.sa-saopaulo-1.oci.oraclecloud.com`). O `openssl` do Git Bash/Git for Windows já vem instalado — não precisa instalar nada.

### Usar o bundle

- **OCI CLI:** `oci os ns get --cert-bundle "C:\Users\<user>\.oci\corpay-ca-bundle.pem"`
- **SDK Python (`oci`)/`pip`/`aws` CLI:** variável de ambiente `REQUESTS_CA_BUNDLE` (funciona para `requests`, que é a base do SDK `oci` e do `boto3`/`awscli` também):
  ```powershell
  $env:REQUESTS_CA_BUNDLE = "C:\Users\<user>\.oci\corpay-ca-bundle.pem"
  ```
- **`pip install`:** `python -m pip install --cert "C:\Users\<user>\.oci\corpay-ca-bundle.pem" <pacote>`

## Gotchas

- O bundle precisa ser **reconstruído se expirar** ou se o Zscaler trocar a cadeia — não é estático. Repetir os dois comandos acima resolve.
- Cada endpoint/host pode retornar uma cadeia ligeiramente diferente dependendo do ponto de saída da rede; se um novo host der o mesmo erro mesmo com o bundle, reconstruir capturando a cadeia **daquele host específico**.
- **Isso é só um problema local.** Dentro de uma Lambda/instância rodando fora da rede Corpay, o Zscaler não intercepta nada e o `certifi` padrão funciona sem ajuste nenhum.

## Referências
- [[Relatorio de custo diario multi-cloud via Lambda + Cost API + SES (padrao Wellington)]]
