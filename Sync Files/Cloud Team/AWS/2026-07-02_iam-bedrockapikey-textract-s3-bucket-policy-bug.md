---
tags: [aws, iam, s3, textract, bedrock, diagnóstico]
date: 2026-07-02
cluster/resource: "IAM user BedrockAPIKey-zwcz / bucket snow-s3-textract-bucket (conta Sandbox 003120962440)"
status: resolvido
---

# Policy inline de acesso do BedrockAPIKey-zwcz ao bucket snow-s3-textract-bucket (TASK1256208)

Chamado: TASK1256208

## Contexto

Solicitação de concessão de permissões para o usuário IAM `BedrockAPIKey-zwcz` no bucket S3 `snow-s3-textract-bucket`, cobrindo:

- Leitura: `s3:ListBucket`, `s3:GetObject`
- Escrita: `s3:PutObject`
- Exclusão: `s3:DeleteObject`

Justificativa do solicitante: o fluxo envolve upload de documentos para o S3 como input do AWS Textract (uso pelo time de ServiceNow — serviço TextExtract), exigindo o ciclo completo de ingestão e organização de arquivos no bucket.

## Diagnóstico

**Localização do bucket:** o bucket não estava em nenhuma das contas Corpay/SemParar conhecidas (`867102406853`, `898720776429`, `145023103800`, `146496228606`, `153488445822`, `342939132704`, `832203986509`, `008357540168`) — todas retornaram `AccessDenied` cross-account em `s3:GetBucketLocation`. O bucket foi localizado na conta **Sandbox (`003120962440`)**.

**Usuário IAM `BedrockAPIKey-zwcz`:**
- Access key ativa (`AKIAQBOQGDOEN4MOX7G4`), criada em 2026-06-30 — credencial de longa duração, sem expiração nativa.
- Managed policies já anexadas: `AmazonTextractFullAccess`, `AmazonBedrockLimitedAccess`.
- Tag do usuário malformada: `Key = "AKIAQBOQGDOEN4MOX7G4"` (o Access Key ID virou o nome da tag) / `Value = "Utilizada pelo time de ServiceNow Servico TextExtract"`.

**Config do bucket `snow-s3-textract-bucket`:**
- Região: us-east-1
- Encryption: SSE-S3 (AES256), Bucket Key habilitado ✅
- Public Access Block: tudo bloqueado ✅
- Sem bucket policy — controle 100% via IAM (consistente com o pedido)
- ⚠️ Versionamento **desabilitado** — risco relevante dado que a policy concede `s3:DeleteObject`: delete acidental ou por aplicação com bug é irrecuperável.

**Bug encontrado na policy inline criada (`snow-s3-textract-bucket`):**

```json
{
    "Sid": "Statement1",
    "Effect": "Allow",
    "Action": ["s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
    "Resource": ["arn:aws:s3:::snow-s3-textract-bucket"]
}
```

`s3:ListBucket` é ação de nível de bucket (ARN sem `/*`), mas `s3:GetObject`, `s3:PutObject` e `s3:DeleteObject` são ações de nível de objeto (exigem ARN com `/*`). Como o `Resource` só tinha o ARN do bucket, na prática somente `ListBucket` funcionaria — as demais ações seriam negadas pelo IAM.

## Resolução

Policy corrigida proposta (pendente de aplicação pelo solicitante/owner da conta Sandbox):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListBucket",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::snow-s3-textract-bucket"
        },
        {
            "Sid": "ObjectActions",
            "Effect": "Allow",
            "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
            "Resource": "arn:aws:s3:::snow-s3-textract-bucket/*"
        }
    ]
}
```

Recomendação adicional: habilitar versionamento no bucket antes de liberar `DeleteObject` em produção, para permitir recuperação de objetos apagados por engano.

**Aplicado ao vivo (2026-07-02):** solicitante chamou no Teams reportando `403 Forbidden — AccessDenied` no `s3:PutObject` (print do erro confirmando exatamente o sintoma previsto acima). Correção aplicada direto no editor de policy IAM do console, consolidando em um único statement com os dois ARNs (bucket + `bucket/*`):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::snow-s3-textract-bucket",
                "arn:aws:s3:::snow-s3-textract-bucket/*"
            ]
        }
    ]
}
```

Status atualizado para resolvido de fato (não mais apenas proposto).

## Comandos relevantes

```bash
# Localizar a conta dona do bucket (probe cross-account)
aws s3api get-bucket-location --bucket snow-s3-textract-bucket --profile <perfil>

# Inspecionar o usuário e a policy inline
aws iam get-user --user-name BedrockAPIKey-zwcz --profile BR_PS_CLOUD-003120962440
aws iam list-user-policies --user-name BedrockAPIKey-zwcz --profile BR_PS_CLOUD-003120962440
aws iam get-user-policy --user-name BedrockAPIKey-zwcz --policy-name snow-s3-textract-bucket --profile BR_PS_CLOUD-003120962440

# Config do bucket
aws s3api get-bucket-versioning --bucket snow-s3-textract-bucket --profile BR_PS_CLOUD-003120962440
aws s3api get-bucket-encryption --bucket snow-s3-textract-bucket --profile BR_PS_CLOUD-003120962440
aws s3api get-public-access-block --bucket snow-s3-textract-bucket --profile BR_PS_CLOUD-003120962440
```

## Lições aprendidas

- Uma requisição HTTP não autenticada (`curl -I https://<bucket>.s3.amazonaws.com/`) confirma existência e região de um bucket S3 sem precisar de credenciais — útil para descartar contas rapidamente antes de testar cada uma via CLI.
- `s3:GetBucketLocation` cross-account retorna `AccessDenied` com a mensagem característica *"because no resource-based policy allows..."* — sinal confiável de que o bucket existe mas pertence a outra conta.
- Policies IAM para S3 exigem resources separados por nível: ARN do bucket para ações de bucket (`ListBucket`) e ARN `bucket/*` para ações de objeto (`GetObject`, `PutObject`, `DeleteObject`). Erro comum ao escrever policy manualmente pelo console.

## Referências

- Bucket: `arn:aws:s3:::snow-s3-textract-bucket` (conta 003120962440, us-east-1)
- Usuário IAM: `arn:aws:iam::003120962440:user/BedrockAPIKey-zwcz`
