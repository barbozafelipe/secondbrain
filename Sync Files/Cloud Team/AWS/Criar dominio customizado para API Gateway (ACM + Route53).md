---
tags: [aws, runbook, api-gateway, acm, route53, dns, processo-padrao]
status: ativo
---

# Criar domínio customizado para API Gateway (ACM + Custom Domain Name + Route53)

> [!info] Quando usar
> Sempre que um novo serviço/API precisar de um subdomínio próprio em `semparardoc.com.br` (ou outra zona da empresa) apontando para um Amazon API Gateway. Primeiro exemplo real: domínio DEV do [[2026-07-02_chatbot-gringo-zendesk-agentcore]] (`chatbot.api.dev.semparardoc.com.br`). Mesmo processo vale para QA, PROD e para outros projetos futuros.

## ⚠️ Por que não dá pra simplesmente criar um CNAME pra URL padrão do API Gateway

A URL padrão (`https://<id>.execute-api.<região>.amazonaws.com`) usa um certificado da AWS emitido para `*.execute-api.<região>.amazonaws.com`. Se o subdomínio da empresa apontar (CNAME) direto pra essa URL, qualquer cliente que valide hostname do certificado (a imensa maioria, incluindo integrações tipo Zendesk) vai rejeitar por **certificate hostname mismatch**. É obrigatório passar por um Custom Domain Name com certificado próprio.

## Passo a passo

> Placeholders usados abaixo: `<FQDN>` = domínio completo a criar (ex: `chatbot.api.dev.semparardoc.com.br`); `<CONTA_ORIGEM>` = conta AWS/org onde vive o API Gateway do serviço (ex: Zapay, conta DEV); `<CONTA_DNS>` = conta AWS/org dona da zona pública (hoje: **Infra, org Corpay**, zona `semparardoc.com.br`); `<API>` / `<STAGE>` = API e stage do API Gateway a expor.

1. **(`<CONTA_ORIGEM>`)** Criar o certificado **ACM** com o Name `<FQDN>`, restante padrão (validação DNS).
2. **(`<CONTA_DNS>`)** Na Hosted Zone, criar um Record Type **CNAME** com:
   - Record Name = o **CNAME name** que o ACM gerou para validação (excluindo a parte final do valor que é `.semparardoc.com.br`, já que ela é implícita pelo domínio da zona)
   - Value = o **CNAME value** que o ACM gerou
   - TTL = 60 segundos
3. Validar no **dnschecker.org** se o CNAME já foi replicado *(não bloqueante — ver pegadinha abaixo: o ACM valida via resolvers internos da AWS antes mesmo do dnschecker mostrar propagado em todo lugar)*.
4. **(`<CONTA_ORIGEM>`)** Confirmar que o status do ACM virou **`Issued`**.
5. **(`<CONTA_ORIGEM>`)** Em **API Gateway → Custom Domain Names**, criar com:
   - Name = `<FQDN>`
   - TLS 1.3 (security policy mais recente disponível)
   - Apontando pro certificado ACM `<FQDN>` criado no passo 1
6. **(`<CONTA_ORIGEM>`)** Confirmar que o status do Custom Domain Name virou **`Available`**.
7. **(`<CONTA_ORIGEM>`)** Fazer o **API mapping** nesse Custom Domain Name, apontando para a `<API>` / stage `<STAGE>` desejados.
8. **(`<CONTA_DNS>`)** Na Hosted Zone, criar outro Record Type **CNAME** com:
   - Record Name = `<FQDN>` sem o sufixo da zona (ex: se a zona é `semparardoc.com.br` e o FQDN é `chatbot.api.dev.semparardoc.com.br`, o Record Name é só `chatbot.api.dev`)
   - Value = o **API Gateway domain name** (target) mostrado no Custom Domain Name criado no passo 5 (algo como `d-xxxxxxxxxx.execute-api.<região>.amazonaws.com`)
   - TTL = 60 segundos
9. **Validar de ponta a ponta** (idealmente via **AWS CloudShell**, ver pegadinha do Zscaler abaixo):
   ```
   curl -v -X POST https://<FQDN>/<rota> -d '{}'
   ```
   Esperado: handshake TLS ok, `subjectAltName` batendo com `<FQDN>`, resposta vindo da aplicação (headers `x-amzn-requestid` / `x-amz-apigw-id` confirmam que chegou no API Gateway).

## Pegadinhas conhecidas

- **Zscaler bloqueia teste manual de domínio novo** — ao rodar o curl de validação do laptop corporativo, o Zscaler intercepta com uma página "category Miscellaneous or Unknown" pedindo confirmação. Isso **não é falha de DNS/TLS**, é só o proxy da empresa desconfiando de domínio recém-criado/não categorizado — não afeta tráfego real de terceiros (ex: Zendesk), que não passa pelo Zscaler da empresa. **Testar via AWS CloudShell** em vez do terminal local pra evitar esse ruído.
- **`403 MissingAuthenticationTokenException` em GET quando a rota só aceita POST é normal** — é a resposta genérica do API Gateway tanto pra "faltou autenticação" quanto pra "método não existe nessa rota". Não confundir com falha real; testar com o método/verbo correto.
- **Padronizar a ordem do nome do subdomínio antes de criar** — no caso do chatbot, teve divergência entre `chatbot.<env>.api...` e `chatbot.api.<env>...` (times diferentes escreveram diferente). Isso aconteceu de verdade: criou-se com o nome errado primeiro, precisou recriar tudo do zero (**ACM não permite renomear um certificado** — é sempre certificado novo + custom domain novo + DNS novo, depois descomissionar o antigo). Definir e documentar o padrão logo no início evita esse retrabalho.
- **Dá pra ter dois Custom Domain Names apontando pra mesma API+stage ao mesmo tempo** — útil durante uma correção de nome tipo a acima: cria o domínio novo, valida, só depois desativa o antigo. Não tem exclusividade/conflito entre eles.

## Ver também

- [[2026-07-02_chatbot-gringo-zendesk-agentcore]] — primeiro caso real onde esse processo foi executado (seção "Domínio DEV — processo executado")
