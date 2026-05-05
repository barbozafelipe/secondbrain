---
tags: [trabalho, sem-parar, aws, iam, sso, padrão]
data: 2026-05-05
---

# Reutilização de Permission Sets existentes para novas contas AWS

> [!info] Contexto
> Quando uma nova conta AWS é incorporada à organização (ex: Afinz, Olho no Carro), os Permission Sets de IAM Identity Center já existentes **não precisam ser recriados** — basta associá-los à nova conta. Essa nota descreve o processo correto para fazer isso via console.

---

## ⚡ TL;DR — o que importa

1. Permission Sets são **globais** no IAM Identity Center — criados uma vez, reutilizados em qualquer conta da organização.
2. O que precisa ser feito para uma nova conta é apenas **criar a atribuição** (Assignment): qual grupo/usuário recebe qual Permission Set naquela conta.
3. Não é necessário recriar políticas, roles ou configurações — tudo já existe.

---

## 🗂️ Como reutilizar um Permission Set em uma nova conta

### Pré-requisito
- A nova conta já deve estar **dentro da organização AWS** (visível no AWS Organizations).
- Você precisa ter acesso ao **IAM Identity Center** na conta de gerenciamento (management account).

---

### Passo a passo

1. Acesse o **AWS IAM Identity Center** pela conta de gerenciamento.
2. No menu lateral, clique em **"AWS accounts"**.
3. Selecione a **nova conta** que você quer configurar.
4. Clique em **"Assign users or groups"**.
5. Escolha o **grupo ou usuário** que deve ter acesso.
6. Selecione o **Permission Set** existente que deseja reutilizar (ex: `AdministratorAccess`, `ReadOnlyAccess`, ou um Permission Set customizado da organização).
7. Clique em **"Submit"**.

> [!tip] O que acontece por baixo
> O IAM Identity Center cria automaticamente uma **Role** na conta de destino com o nome `AWSReservedSSO_<NomeDoPermissionSet>_<hash>`. Essa Role tem a trust policy apontando para o SSO, então o usuário consegue assumir a role ao acessar pelo portal.

---

## 🔑 Decisões e pontos de atenção

| Ponto | Detalhe |
|---|---|
| Quem pode fazer isso | Apenas quem tem acesso ao IAM Identity Center na management account |
| Permission Set customizado não existe? | Crie primeiro em **Permission sets → Create permission set**, depois atribua |
| Mudanças no Permission Set | Afetam **todas as contas** onde ele está atribuído — cuidado ao editar |
| Propagação | A Role na conta de destino é provisionada automaticamente após o Submit — pode demorar alguns minutos |

---

## 📌 Glossário

| Termo | O que é |
|---|---|
| **IAM Identity Center** | Serviço AWS central de SSO — gerencia usuários, grupos e acessos multi-conta (antes chamado AWS SSO) |
| **Permission Set** | Conjunto de políticas IAM definido centralmente no Identity Center — reutilizável em qualquer conta da org |
| **Assignment** | Vínculo entre um usuário/grupo, um Permission Set e uma conta AWS específica |
| **Management Account** | Conta raiz da AWS Organization — onde o Identity Center é configurado |
| **AWSReservedSSO_*** | Role criada automaticamente nas contas-membro quando um Permission Set é atribuído |
