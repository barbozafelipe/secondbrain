
# CLF-C02 - Security and Compliance

**Domínio 2 · 30% da prova** | Parte de: [[AWS Certified Cloud Practitioner]]

---

## 🔔 Lembrete 1 — Revisar Security & Compliance

**Data:** 14/05/2026 (Qui) · 16h | ⏱️ Tempo estimado: 45 min

> [!info] Primeiro passo (2 min)
> Leia os títulos do checklist abaixo e mentalmente marque o que você **já usa no trabalho** (IAM Identity Center, Permission Sets, CloudTrail, KMS — você lida com isso todo dia). Perceber o que já sabe libera dopamina e reduz a resistência para começar.

> [!success] Ao terminar esta sessão
> Você terá coberto **54% do peso total da prova** (24% Cloud Concepts + 30% Security). Mais da metade feita.

---

**Domínio 2 · 30% da prova**
Parte de: [[AWS Certified Cloud Practitioner]]

---

## ✅ Checklist de Estudo

- [x] Shared Responsibility Model (security OF vs. IN the cloud)
- [x] IAM: Users, Groups, Roles, Policies e Least Privilege
- [ ] IAM Identity Center (SSO) — acesso centralizado multi-conta
- [ ] Permission Sets — conjuntos de permissão reutilizáveis em Identity Center
- [ ] MFA e boas práticas de conta root
- [ ] GuardDuty — detecção de ameaças via ML
- [ ] Inspector — scan de vulnerabilidades em EC2 e containers
- [ ] Macie — descoberta de dados sensíveis (PII) no S3
- [ ] Shield Standard e Advanced — proteção DDoS
- [ ] WAF — Web Application Firewall
- [ ] Secrets Manager e KMS — gestão de credenciais e chaves
- [ ] CloudTrail — auditoria de todas as chamadas de API
- [ ] AWS Artifact — relatórios de conformidade (SOC, PCI, ISO, HIPAA)
- [ ] AWS Config — auditoria de conformidade contínua de recursos
- [ ] Criptografia em trânsito (TLS/HTTPS) e em repouso (SSE, KMS)

---

## Shared Responsibility Model

| Camada | Responsável |
|--------|------------|
| Hardware, rede física, datacenters | **AWS** |
| Hypervisor, serviços gerenciados | **AWS** |
| SO (em EC2), patches, configuração | **Cliente** |
| Dados, IAM, criptografia de app | **Cliente** |

> Regra rápida: **security OF the cloud** = AWS · **security IN the cloud** = cliente

---

## IAM — Identity and Access Management

- **Users** — identidade individual (evitar usar root)
- **Groups** — conjunto de users com mesmas permissões
- **Roles** — identidade assumida por serviços ou federated users (sem credenciais estáticas)
- **Policies** — JSON que define Allow/Deny em ações e recursos
- **MFA** obrigatório para root e usuários com acesso ao console
- **Least privilege**: conceder apenas o necessário

---

## IAM Identity Center (AWS SSO)

O IAM Identity Center é o serviço centralizado de **Single Sign-On (SSO)** da AWS para ambientes multi-conta.

### Como funciona

```
Provedor de Identidade (AD / Okta / Sailpoint)
        |
        v
AWS IAM Identity Center
        |
        +--→ Conta DEV  + Permission Set DEV
        |
        +--→ Conta QA   + Permission Set QA
        |
        +--→ Conta PRD  + Permission Set PRD (read-only)
```

### Conceitos-chave para a prova

| Conceito | O que é |
|---|---|
| **Permission Set** | Conjunto de políticas IAM definido centralmente — reutilizável em qualquer conta da org |
| **Assignment** | Vínculo entre Grupo/Usuário + Permission Set + Conta AWS |
| **Management Account** | Conta raiz da organização — onde o Identity Center é configurado |
| **Portal SSO** | Interface web onde o usuário loga com credenciais corporativas e vê suas contas/roles |

> [!tip] 🔗 Conexão com o trabalho
> Você opera o IAM Identity Center diariamente. As tasks ZPY (PTSK0010372) e ZPY- Reutilização de Permission Sets descrevem exatamente esse fluxo:
> - Grupo `BR_AWSZPY_IA_DEVELOPER` criado no AD → sincronizado via Okta → aparece no IAM Identity Center
> - Você associa: **Grupo + Conta (DEV/QA/PRD) + Permission Set correspondente**
> - A AWS cria automaticamente uma Role `AWSReservedSSO_<NomeDoPermissionSet>_<hash>` na conta de destino
>
> Para a prova: **Permission Sets são globais** no Identity Center — criados uma vez, reutilizados em qualquer conta. O que muda por conta é o **Assignment** (quem tem qual permissão naquela conta específica).
>
> Paralelo com Azure: é o mesmo conceito que você acabou de fazer com a role `acesso-dbas` — mas na AWS, o IAM Identity Center centraliza isso para múltiplas contas com muito mais granularidade por ambiente.

---

## Serviços de segurança relevantes para a prova

| Serviço | O que faz |
|---------|-----------|
| **GuardDuty** | Detecção de ameaças via ML (logs de VPC, DNS, CloudTrail) |
| **Inspector** | Scan de vulnerabilidades em EC2 e imagens de container |
| **Macie** | Descoberta de dados sensíveis (PII) no S3 |
| **Shield Standard** | Proteção DDoS automática e gratuita |
| **Shield Advanced** | DDoS com suporte 24/7 e SLA financeiro |
| **WAF** | Firewall de aplicação web (regras customizáveis) |
| **Secrets Manager** | Rotação automática de credenciais |
| **KMS** | Gerenciamento de chaves de criptografia |
| **CloudTrail** | Auditoria de todas as chamadas de API |

---

## Compliance

- AWS publica relatórios de conformidade no **AWS Artifact** (SOC 1/2/3, PCI DSS, ISO 27001, HIPAA...)
- O cliente é responsável pela conformidade dos próprios dados e aplicações
- **AWS Config** — audita conformidade de recursos ao longo do tempo

---

## Encryption

- **Em trânsito**: TLS/SSL (HTTPS)
- **Em repouso**: SSE-S3, SSE-KMS, SSE-C (S3); criptografia de volume EBS; RDS encryption

> [!tip] 🔗 Conexão com o trabalho
> Nas tasks de certificado (CTASK0133893 e CTASK0134619), você gerenciou exatamente a **criptografia em trânsito**: os certificados TLS que ficam no ACM e são usados pelos ALBs para estabelecer conexões HTTPS. Isso é "encryption in transit" — o servidor apresenta o certificado, o browser valida, a conexão é criptografada. Para a prova: certificados TLS = criptografia em trânsito.

%% Begin Waypoint %%
- [[Políticas - IAM]]
- [[Responsabilidade compartilhada]]

%% End Waypoint %%
