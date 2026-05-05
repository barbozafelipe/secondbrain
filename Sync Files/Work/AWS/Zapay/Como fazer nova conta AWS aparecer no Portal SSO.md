---
tags: [trabalho, sem-parar, aws, iam, sso, padrão]
data: 2026-05-05
---

# Como fazer a nova conta AWS aparecer no Portal SSO

> [!info] Contexto
> Quando uma nova conta AWS entra na organização (ex: Afinz, Olho no Carro), ela **não aparece automaticamente** no portal do usuário (`https://<org>.awsapps.com/start`). Para aparecer, a conta precisa ter pelo menos um **Assignment** — ou seja, um grupo/usuário associado a um Permission Set naquela conta. Sem isso, o portal simplesmente não a lista.

---

## ⚡ TL;DR — o que importa

1. A conta só aparece no portal SSO **depois que um Assignment é criado** para ela no IAM Identity Center.
2. Não basta a conta estar na Organization — é o Assignment que "ativa" a conta para os usuários.
3. Uma vez criado o Assignment, a conta aparece no portal em **alguns minutos**.

---

## 🗂️ Passo a passo para a conta aparecer no portal

### Pré-requisito
- A conta já deve estar na **AWS Organization** (verificável em Organizations → Accounts).
- Acesso ao **IAM Identity Center** na management account.

---

### Etapas

1. Acesse o **AWS IAM Identity Center** pela management account.
2. No menu lateral, clique em **"AWS accounts"**.
3. Localize e selecione a **nova conta** na lista.

   > [!warning] A conta não aparece na lista?
   > Se a conta não aparecer em "AWS accounts" dentro do Identity Center, provavelmente ela ainda **não está registrada na Organization**. Verifique em AWS Organizations se a conta está visível. Se foi uma conta recém-criada via Control Tower ou Organizations Invite, pode levar alguns minutos para sincronizar.

4. Clique em **"Assign users or groups"**.
5. Selecione o **grupo** (ex: `Cloud-Admins`, `Infra-ReadOnly`) ou usuário que deve ter acesso.
6. Selecione o **Permission Set** adequado.
7. Clique em **"Submit"**.
8. Aguarde a **propagação** (geralmente 1–3 minutos).
9. Acesse o **portal SSO** (`https://<org>.awsapps.com/start`) e a conta já estará visível para os usuários do grupo escolhido.

---

## 🔑 Decisões e pontos de atenção

| Ponto | Detalhe |
|---|---|
| Por que a conta não aparece sem Assignment? | O portal SSO só lista contas onde o usuário logado tem pelo menos um Assignment ativo |
| Quem vê a conta | Apenas usuários/grupos com Assignment naquela conta — visibilidade é por usuário, não global |
| Tempo de propagação | Normalmente 1–5 minutos após o Submit; role é criada automaticamente na conta de destino |
| Conta criada via Control Tower | O CT pode criar Assignments automáticos para grupos pré-definidos — verifique antes de criar manualmente |
| Conta migrada de fora da org | Pode exigir aceite de convite (Invite Account) antes de aparecer no Organizations |

---

## 🔁 Relação com a nota anterior

> [!tip] Ver também
> Este processo é o mesmo descrito em [[Reutilização de Permission Sets para novas contas AWS]]. A diferença de foco é:
> - Aquela nota responde: *"posso reaproveitar o Permission Set que já existe?"* → **Sim.**
> - Esta nota responde: *"como faço a conta aparecer no portal para os usuários?"* → **Crie o Assignment.**
> Na prática, as duas ações acontecem juntas.

---

## 📌 Glossário

| Termo | O que é |
|---|---|
| **Portal SSO** | Interface web onde o usuário loga com suas credenciais Corpay e vê as contas/roles disponíveis |
| **Assignment** | Associação entre usuário/grupo + Permission Set + conta AWS — é o que "publica" uma conta no portal |
| **IAM Identity Center** | Serviço central de SSO da AWS — gerencia acessos multi-conta via SAML/OIDC |
| **Permission Set** | Conjunto de políticas IAM reutilizável em qualquer conta da organização |
| **Control Tower** | Serviço AWS de governança que provisiona contas e pode criar Assignments automáticos via Account Factory |
| **Organization** | Estrutura AWS que agrupa múltiplas contas sob um pagador único e permite políticas centralizadas (SCPs) |
