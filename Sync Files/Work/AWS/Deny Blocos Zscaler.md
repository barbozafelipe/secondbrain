

````markdown
# Contexto completo da análise - Erro de acesso no Route 53 por Deny de IP no Permission Set

## Resumo do caso

Foi analisado um problema de permissão de um usuário chamado Thiago da área de SI ao acessar o Route 53 na AWS. Inicialmente parecia ser falta de permissão no serviço Route 53, mas depois ficou claro que o usuário já possuía permissões administradas da AWS para Route 53 e Route 53 Domains no Permission Set. O problema real era um `Deny` explícito em uma inline policy do Permission Set `BR_PS_SEGURANCA`, condicionado por IP de origem.

O erro acontecia porque existia uma regra antiga no próprio Permission Set negando qualquer ação AWS quando o acesso não vinha de determinados blocos de IP. Esses blocos eram relacionados aos IPs antigos de saída/Zscaler/corporativos. Como recentemente houve mudança nos blocos de IP utilizados, usuários que estavam saindo pelos novos IPs não estavam contemplados nessa allowlist antiga e acabavam sendo bloqueados.

A solução aplicada foi remover do Permission Set o bloco inteiro de `Deny` por `aws:SourceIp`, pois o controle correto de IP já existe centralizado via SCP na AWS Organizations, especificamente na policy `DenyAccessToAWS-FilterIP`.

Após a remoção do bloco duplicado no inline do Permission Set, o Thiago testou novamente e o acesso funcionou.

---

## Ambiente / recurso envolvido

- Serviço afetado: AWS Route 53
- Conta afetada observada no erro: `867102406853`
- Usuário afetado: `thiago.ssantos@corpay.com.br`
- Acesso via AWS IAM Identity Center / AWS SSO
- Role assumida pelo usuário:
  `AWSReservedSSO_BR_PS_SEGURANCA_f071531e61813280`
- Permission Set analisado:
  `BR_PS_SEGURANCA`
- AWS Organizations também foi verificado para confirmar existência de controle centralizado via SCP.

---

## Erros observados

No painel do Route 53, a tela apresentava erro ao carregar o dashboard. O banner do console mostrava algo genérico como:

- `O Route 53 não conseguiu atualizar a página`
- `O Route 53 encontrou um erro desconhecido e não foi possível atualizar sua página`
- `UnknownError`

Ao expandir as mensagens de erro de API, apareciam erros de autorização com `explicit deny`.

Foram observadas mensagens como:

```text
User: arn:aws:sts::867102406853:assumed-role/AWSReservedSSO_BR_PS_SEGURANCA_f071531e61813280/thiago.ssantos@corpay.com.br is not authorized to perform: route53domains:ListOperations on resource: * with an explicit deny in an identity-based policy
````

```text
User: arn:aws:sts::867102406853:assumed-role/AWSReservedSSO_BR_PS_SEGURANCA_f071531e61813280/thiago.ssantos@corpay.com.br is not authorized to perform: route53domains:ListDomains on resource: * with an explicit deny in an identity-based policy
```

Também apareceu erro relacionado a hosted zones, como:

```text
User is not authorized to perform: route53:GetHostedZoneCount with an explicit deny in an identity-based policy
```

Esse detalhe é importante: o painel inicial do Route 53 tenta carregar várias informações ao mesmo tempo, como hosted zones, domains, health checks, traffic policies etc. Então o erro pode aparecer em ações diferentes, por exemplo:

- `route53:GetHostedZoneCount`
    
- `route53domains:ListDomains`
    
- `route53domains:ListOperations`
    

Mas todas estavam sendo afetadas pela mesma causa raiz: um `Deny` explícito aplicável a qualquer ação (`Action: "*"`) quando o acesso vinha de fora da lista de IPs permitidos.

---

## Primeira suspeita

A primeira suspeita foi falta de permissão em Route 53, porque o console exibia erro justamente no painel do Route 53.

Porém, ao analisar o Permission Set `BR_PS_SEGURANCA`, foi visto que ele já possuía policies administradas da AWS relacionadas a Route 53:

- `AmazonRoute53DomainsFullAccess`
    
- `AmazonRoute53FullAccess`
    

Ou seja, o problema não era simplesmente falta de `Allow` para Route 53.

---

## Entendimento importante sobre IAM

Mesmo que uma role/permission set tenha uma policy com `Allow`, qualquer `Deny` explícito vence.

A lógica prática é:

```text
Explicit Deny > Allow
```

Então, mesmo com `AmazonRoute53FullAccess` e `AmazonRoute53DomainsFullAccess`, o acesso continuava sendo bloqueado porque havia um `Deny` explícito em uma inline policy do Permission Set.

---

## Inline policy encontrada no Permission Set

No Permission Set `BR_PS_SEGURANCA`, havia uma inline policy configurada.

Caminho utilizado:

```text
AWS IAM Identity Center
→ Permission sets
→ BR_PS_SEGURANCA
→ Permissions
→ Inline policy
→ Edit
```

A inline policy tinha alguns blocos, incluindo:

1. Um `Deny` para serviços de billing/cost:
    

```json
{
  "Effect": "Deny",
  "Action": [
    "Aws-portal:*",
    "Ce:*",
    "Budgets:*",
    "Cur:*"
  ],
  "Resource": "*"
}
```

2. Um bloco problemático de `Deny` geral por IP de origem:
    

```json
{
  "Effect": "Deny",
  "Action": "*",
  "Resource": "*",
  "Condition": {
    "NotIpAddress": {
      "aws:SourceIp": [
        "64.215.22.0/24",
        "165.225.214.0/23",
        "147.161.128.0/23",
        "165.225.222.0/23",
        "197.98.201.0/24",
        "165.225.34.0/23",
        "200.189.171.134",
        "136.226.62.0/23"
      ]
    },
    "Bool": {
      "aws:ViaAWSService": "false"
    }
  }
}
```

3. Um bloco de allow para API Gateway ReadOnly.
    
4. Um bloco de allow para CloudShell.
    

O bloco problemático era o segundo, porque ele negava qualquer ação (`Action: "*"`) em qualquer recurso (`Resource: "*"`) quando o IP de origem não estava na lista.

---

## Interpretação do bloco problemático

O statement fazia o seguinte:

```text
Negar qualquer ação AWS se o IP de origem do usuário NÃO estiver dentro dos blocos permitidos.
```

A condição usada era:

```json
"NotIpAddress": {
  "aws:SourceIp": [...]
}
```

Ou seja, se o usuário acessasse a AWS a partir de um IP que não estivesse na lista, a condição seria verdadeira e o `Deny` seria aplicado.

Também havia:

```json
"Bool": {
  "aws:ViaAWSService": "false"
}
```

Essa condição evita bloquear chamadas feitas por serviços AWS em determinados contextos. Na prática, o deny era focado em chamadas diretas feitas pelo usuário, não chamadas encadeadas por serviços AWS.

---

## Cuidado importante na edição

Um ponto muito importante: não se deve remover apenas o `Condition` desse statement.

Se remover somente o `Condition`, o bloco vira isto:

```json
{
  "Effect": "Deny",
  "Action": "*",
  "Resource": "*"
}
```

Isso causaria um bloqueio total para o Permission Set, porque passaria a negar absolutamente todas as ações sem condição.

A ação correta, neste caso, foi remover o statement inteiro que fazia o Deny por IP.

Ou seja, remover todo este bloco:

```json
{
  "Effect": "Deny",
  "Action": "*",
  "Resource": "*",
  "Condition": {
    "NotIpAddress": {
      "aws:SourceIp": [
        "64.215.22.0/24",
        "165.225.214.0/23",
        "147.161.128.0/23",
        "165.225.222.0/23",
        "197.98.201.0/24",
        "165.225.34.0/23",
        "200.189.171.134",
        "136.226.62.0/23"
      ]
    },
    "Bool": {
      "aws:ViaAWSService": "false"
    }
  }
}
```

---

## JSON final recomendado para o Permission Set após remoção do bloco de IP

Após remover o statement de Deny por IP, a inline policy ficou mantendo apenas os demais blocos necessários:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": [
        "Aws-portal:*",
        "Ce:*",
        "Budgets:*",
        "Cur:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "APIGatewayReadOnly",
      "Effect": "Allow",
      "Action": [
        "apigateway:GET",
        "apigateway:ListRoutingRules",
        "apigateway:GetRoutingRule"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudShell",
      "Effect": "Allow",
      "Action": [
        "cloudshell:*"
      ],
      "Resource": "*"
    }
  ]
}
```

O objetivo foi remover apenas o controle de IP duplicado no Permission Set, sem mexer no Deny de billing/custos e sem remover os allows existentes.

---

## Por que foi seguro remover do Permission Set

Durante a conversa com o Thiago, foi informado que o controle desses IPs deveria ficar centralizado na AWS Organizations, via SCP.

Foi então consultado o AWS Organizations:

```text
AWS Organizations
→ Policies
→ Service control policies
```

Lá foi encontrada uma Service Control Policy chamada:

```text
DenyAccessToAWS-FilterIP
```

Descrição da policy:

```text
Negando acesso as contas AWS que nao venham por IPS de origem
```

Essa policy já centraliza o controle de acesso por IP para a organização.

---

## SCP encontrada na AWS Organizations

A SCP encontrada tem conteúdo semelhante a este:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "64.215.22.0/24",
            "165.225.214.0/23",
            "147.161.128.0/23",
            "165.225.222.0/23",
            "197.98.201.0/24",
            "165.225.34.0/23",
            "200.189.171.134",
            "136.226.62.0/23",
            "136.226.120.0/23",
            "201.72.145.18/28",
            "177.19.186.226/29",
            "189.2.204.98/28",
            "189.112.14.105/29",
            "177.19.170.91/29",
            "189.42.46.100/26",
            "75.2.98.97/32",
            "99.83.150.238/32",
            "98.98.27.0/24",
            "159.254.64.0/23",
            "136.226.138.0/23",
            "136.226.140.0/23",
            "170.85.16.0/23",
            "170.85.18.0/23",
            "170.85.20.0/23",
            "170.85.22.0/23",
            "170.85.24.0/23"
          ]
        },
        "Bool": {
          "aws:ViaAWSService": "false"
        },
        "ArnEquals": {
          "aws:PrincipalARN": [
            "arn:aws:iam::*:role/*BR_*",
            "arn:aws:iam::*:role/AWS_PARCERIAS_PRD_SANTANDER_LOGS*"
          ]
        }
      }
    }
  ]
}
```

Essa SCP tem uma lista mais atualizada de blocos de IP. A inline policy antiga do Permission Set tinha uma lista menor e desatualizada.

---

## Diferença entre Permission Set inline policy e SCP

A inline policy no Permission Set afeta as roles criadas pelo IAM Identity Center nas contas AWS. No caso, o usuário acessava via uma role SSO:

```text
AWSReservedSSO_BR_PS_SEGURANCA_f071531e61813280
```

A SCP, por outro lado, fica na AWS Organizations e é aplicada em nível organizacional, podendo afetar contas, OUs ou a Root da organização.

Resumo:

```text
Permission Set / Inline Policy = permissões e restrições da role SSO
SCP = limite máximo centralizado aplicado pela AWS Organizations
```

A SCP não concede permissão. Ela apenas define o limite máximo permitido. Mesmo que uma role tenha permissão, a SCP pode bloquear. Porém, neste caso específico, o erro apontava `identity-based policy`, então a causa direta era o Deny dentro do Permission Set.

A SCP foi relevante porque confirmou que o controle de IP já existe centralizado em outro lugar. Por isso fazia sentido remover a duplicidade do Permission Set.

---

## Explicação dada ao usuário afetado

Foi explicado ao Thiago algo nesse sentido:

```text
Antigamente existiam alguns blocos específicos que o Zscaler liberava para a gente sair para a internet, e existia uma regra nos grupos/permission sets da AWS permitindo acesso aos recursos somente quando os usuários vinham desses blocos.

Há mais ou menos 1 mês, foi feita alguma alteração e agora existem outros blocos de saída. Como os novos blocos não tinham sido incluídos nessa regra antiga do Permission Set, usuários que estavam saindo por esses novos IPs ficavam fora da allowlist e recebiam erro de permissão.

A ação feita foi remover do inline do Permission Set esse Deny por blocos de IP, porque esse controle já existe via SCP na AWS Organizations, que é o local correto para centralizar esse tipo de regra.
```

Após isso, o Thiago testou o acesso novamente e confirmou que funcionou.

---

## Diagnóstico final

Causa raiz:

```text
Deny explícito por IP de origem na inline policy do Permission Set BR_PS_SEGURANCA.
```

O Deny usava uma lista antiga/desatualizada de IPs permitidos. Como o usuário estava saindo por IP fora dessa lista, o Permission Set negava qualquer ação AWS, inclusive chamadas do Route 53.

Erro manifestado no console:

```text
Route 53 não conseguia carregar o painel.
```

APIs bloqueadas observadas:

```text
route53domains:ListOperations
route53domains:ListDomains
route53:GetHostedZoneCount
```

Motivo técnico:

```text
explicit deny in an identity-based policy
```

Solução aplicada:

```text
Removido o statement inteiro de Deny por aws:SourceIp da inline policy do Permission Set BR_PS_SEGURANCA.
```

Justificativa da solução:

```text
O controle de IP já existe centralizado na AWS Organizations via SCP DenyAccessToAWS-FilterIP, com lista mais atualizada de IPs.
```

Resultado:

```text
Usuário testou novamente e o acesso funcionou.
```

---

## Como identificar esse problema no futuro

Quando aparecer erro no console AWS com algo como:

```text
is not authorized to perform ... with an explicit deny in an identity-based policy
```

não olhar apenas se existe uma policy com `Allow`.

É necessário procurar por `Deny` explícito nos seguintes lugares:

1. Inline policy do Permission Set no IAM Identity Center
    
2. Policies anexadas ao Permission Set
    
3. Permission boundary
    
4. SCP na AWS Organizations
    
5. Session policy, se houver
    
6. Policies diretamente associadas à role/usuário, dependendo do tipo de acesso
    

Neste caso, como o erro dizia `identity-based policy`, a investigação correta foi olhar o Permission Set/role SSO antes de assumir que era SCP.

---

## Checklist para troubleshooting parecido

1. Identificar o usuário e a role assumida no erro.  
    Exemplo:
    
    ```text
    arn:aws:sts::<account-id>:assumed-role/AWSReservedSSO_<permission-set>/<usuario>
    ```
    
2. Identificar o Permission Set correspondente.  
    Exemplo:
    
    ```text
    AWSReservedSSO_BR_PS_SEGURANCA...
    → Permission Set: BR_PS_SEGURANCA
    ```
    
3. Verificar se o Permission Set tem as policies de Allow necessárias.  
    Neste caso, tinha:
    
    ```text
    AmazonRoute53FullAccess
    AmazonRoute53DomainsFullAccess
    ```
    
4. Procurar inline policy no Permission Set.
    
5. Procurar por statements com:
    
    ```json
    "Effect": "Deny"
    ```
    
6. Verificar se existe Deny com:
    
    ```json
    "Action": "*"
    ```
    
    e condição por IP:
    
    ```json
    "NotIpAddress": {
      "aws:SourceIp": [...]
    }
    ```
    
7. Nunca remover apenas o `Condition` de um Deny geral. Remover o statement inteiro ou ajustar a condição corretamente.
    
8. Validar se o controle já existe em SCP na AWS Organizations.
    
9. Se o controle correto for via SCP, remover duplicidade do Permission Set.
    
10. Salvar alteração e aguardar o reprovisionamento do Permission Set nas contas.
    
11. Pedir para o usuário fazer logout/login no AWS SSO, se necessário.
    
12. Testar novamente o acesso.
    

---

## Observação sobre reprovisionamento

Como o Permission Set estava aplicado em várias contas, a alteração pode exigir reprovisionamento automático pelo IAM Identity Center. Em alguns casos, o efeito pode não ser imediato se a role/sessão do usuário ainda estiver ativa.

Boa prática após alteração:

```text
1. Salvar alteração no Permission Set.
2. Aguardar reprovisionamento.
3. Pedir para o usuário sair e entrar novamente no AWS SSO.
4. Testar novamente.
```

---

## Ancoragem mental

Este caso não era um problema de falta de permissão no Route 53.

Era um caso clássico de:

```text
"Usuário tem Allow, mas existe um Deny explícito vencendo."
```

A tela enganava porque o erro aparecia dentro do Route 53, mas o bloqueio real era global:

```json
"Action": "*",
"Resource": "*"
```

com condição por IP.

O painel do Route 53 apenas foi o primeiro lugar onde o erro ficou visível.

---

## Frase curta para lembrar

```text
Se o erro diz explicit deny, não adianta procurar só Allow. Procure o Deny.
```

E neste caso específico:

```text
Route 53 quebrava porque o Permission Set tinha um Deny por IP antigo. O controle correto estava na SCP centralizada.
```