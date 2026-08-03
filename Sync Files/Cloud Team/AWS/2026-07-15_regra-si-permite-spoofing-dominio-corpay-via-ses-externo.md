---
tags: [aws, ses, seguranca, spoofing, phishing, spf, si, achado]
date: 2026-07-15
status: reportar-para-SI
---

# Achado — regra de SI permite qualquer conta SES externa enviar e-mail como `@corpay.com.br`

## Contexto

Durante a implementação do relatório de custo diário via Lambda + SES (ver [[Relatorio de custo diario multi-cloud via Lambda + Cost API + SES (padrao Wellington)]]), o Felipe comentou com **Ithallo Oliveira Nunes** (infra) que conseguiu enviar e-mail com sucesso via SES a partir de uma conta AWS própria. Ithallo respondeu (Teams, 2026-07-15):

> "Show, tem uma regra 'errada' em SI que libera todo o SES a mandar email como corpay..rsrs
> então se você fizer isso de uma conta particular, se consegue mandar para qualquer pessoa"

## O que isso significa (interpretação técnica)

"SI" = **Segurança da Informação** (o time, não um acrônimo técnico de e-mail). Ithallo está dizendo que existe uma **regra configurada pelo próprio time de SI** — muito provavelmente o registro **SPF** do domínio `corpay.com.br` (ou uma allowlist equivalente em algum gateway de e-mail) — que ficou permissiva demais: ela autoriza **toda a infraestrutura compartilhada do Amazon SES**, não apenas a conta AWS payer autorizada da Corpay (`898720776429`).

Na prática, isso provavelmente significa que:
- **Qualquer pessoa** com uma conta AWS pessoal/externa, verificando uma identidade `@corpay.com.br` no SES dela, consegue mandar e-mail que passa nas validações de autenticidade (SPF e possivelmente DKIM/DMARC dependendo de como estão configurados) **como se fosse legítimo da Corpay**.
- Isso vale para **qualquer destinatário**, dentro ou fora da empresa — não é limitado a caixas já conhecidas.

Isso é um vetor clássico de **spoofing / BEC (Business Email Compromise)**: alguém malicioso poderia se passar por `financeiro@corpay.com.br`, `ti@corpay.com.br` etc. para golpes de phishing direcionado, sem precisar comprometer nenhuma credencial da Corpay — só precisa de uma conta AWS gratuita.

## Status

**Não investigado a fundo, não explorado além do uso legítimo já em andamento** (o relatório de custo, autorizado e restrito à conta payer). Ithallo mencionou de forma informal, via chat — **não foi aberto chamado formal para o time de SI ainda**.

## Ação recomendada

- [ ] Confirmar com Ithallo os detalhes exatos da regra (qual sistema, qual registro DNS/configuração exatamente está permissivo)
- [ ] Abrir chamado formal para o time de SI (não deixar só no chat informal) — é o dono da regra e quem precisa corrigir
- [ ] Verificar registro SPF atual de `corpay.com.br` (`dig TXT corpay.com.br` ou equivalente) e checar se o mecanismo `include:amazonses.com` (ou similar) está sem escopo — o ideal é restringir a mecanismos que validem a conta/origem específica autorizada, não a infra inteira de um provedor de e-mail em massa
- [ ] Verificar também DKIM/DMARC — mesmo com SPF solto, DMARC bem configurado (`p=reject` + alinhamento estrito) mitigaria parte do risco

## Referências
- [[Relatorio de custo diario multi-cloud via Lambda + Cost API + SES (padrao Wellington)]]
