**Domínio 2 · 30% da prova**
Parte de: [[AWS Certified Cloud Practitioner]]

---

## ✅ Checklist de Estudo

- [ ] Shared Responsibility Model (security OF vs. IN the cloud)
- [ ] IAM: Users, Groups, Roles, Policies e Least Privilege
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

## IAM — Identity and Access Management

- **Users** — identidade individual (evitar usar root)
- **Groups** — conjunto de users com mesmas permissões
- **Roles** — identidade assumida por serviços ou federated users (sem credenciais estáticas)
- **Policies** — JSON que define Allow/Deny em ações e recursos
- **MFA** obrigatório para root e usuários com acesso ao console
- **Least privilege**: conceder apenas o necessário

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

## Compliance

- AWS publica relatórios de conformidade no **AWS Artifact** (SOC 1/2/3, PCI DSS, ISO 27001, HIPAA...)
- O cliente é responsável pela conformidade dos próprios dados e aplicações
- **AWS Config** — audita conformidade de recursos ao longo do tempo

## Encryption

- **Em trânsito**: TLS/SSL (HTTPS)
- **Em repouso**: SSE-S3, SSE-KMS, SSE-C (S3); criptografia de volume EBS; RDS encryption
