---
tags: [aws, vpc, databricks, security-group, routing, vpn, diagnóstico]
date: 2026-06-12
cluster/resource: vpc-04b8a21f9ad99be66 (DNA-DTK, conta DLA PRD 284309077449, sa-east-1)
status: resolvido
---

## Contexto

Incidente: subnets privadas do workspace Databricks com VPC injection (customer-managed VPC) na conta **DLA PRD (284309077449, sa-east-1)** pararam de conseguir fazer saída TCP para dois destinos SFTP/FTP externos:

- **Mundiale**: 8.242.38.247:8021 (TCP) — prioridade
- **Trabbe**: 100.112.45.221:21 (TCP) — IP CGNAT (100.64.0.0/10)

Origem: subnets `10.12.26.0/25`, `10.12.27.0/25`, `10.12.26.128/25`, `10.12.27.128/25`.

Suspeita inicial: regra de SG/NACL/Network Firewall removida recentemente.

## Diagnóstico

**Ambiente identificado:**
- VPC `vpc-04b8a21f9ad99be66` (tag Name: `DNA-DTK`), CIDR `10.12.24.0/22`, sa-east-1
- Stack CloudFormation `dna` — tags `project=databricks`, `frente=dla`, `enviroment=prod`
- Subnets: `subnet-021527509ed936073` (AZ1), `subnet-0378f5270028aa831` (AZ2), `subnet-0d5e8e2d9b653f44b` (AZ1), `subnet-04155ca90f4be63ec` (AZ2)
- NACL: única, default (`acl-02acfae39e7cf7dae`), allow-all — não é limitante
- Security Group: `sg-075d0a1313104ca2c` (`dna-databricks-cloud-formation-prod-DBSWorkspaceSG`)
- Route table: `rtb-00b242627ea9a31cf` (`ROUTE-TABLE-DATABRICKS-PRIVATE-TABLE`)
  - `0.0.0.0/0 → nat-130ac2426412e2126` (NAT Gateway regional, EIPs 56.126.139.136 e 56.126.99.63)
  - ~25 rotas propagadas via `EnableVgwRoutePropagation` para `vgw-0b5ff8513545f7c5d` (DLADTK-VGW-DNA), incluindo CGNAT `100.64.25.0/29`, `100.64.25.37/32`, `100.96.25.0/29`
- VGW `vgw-0b5ff8513545f7c5d`: attached, porém **`describe-vpn-connections` retorna vazio** — sem VPN connection ativa. Rotas propagadas são "órfãs".
- Transit Gateway `tgw-0680bc1ce1f31521b` existe na região mas é de outra conta (324655798825) e sem attachment nesta VPC.
- VPC Flow Logs: **não habilitados** (lista vazia)
- AWS Network Firewall: **não existe** nesta VPC

**Mundiale (8.242.38.247:8021):**
- SG egress TCP/8021 → 8.242.38.247/32 EXISTE (descrição "CHG0094012 - Marcio 05.03.26")
- NACL allow-all, rota default → NAT saudável
- Path estático: **PERMITIDO em todas as camadas** — sem evidência de regra removida
- Hipótese provável: allowlist de IP de origem do lado do parceiro desatualizada (NAT IPs atuais: 56.126.139.136 / 56.126.99.63) ou modo FTP passivo exigindo range de portas adicional

**Trabbe (100.112.45.221:21):**
- `100.112.45.221` é CGNAT (RFC 6598) — não roteável na Internet pública
- Não está coberto por nenhuma rota propagada via VGW (apenas 100.64.25.0/29 e 100.96.25.0/29 estão propagados, não cobrem .112.)
- Cairia na rota default pública → NAT/IGW não conseguem entregar pacote a um IP CGNAT
- SG também não tem regra de egress TCP/21 para esse IP (dupla falha, mas roteamento é a causa raiz)
- **Conclusão: timeout do Trabbe é problema de ROTEAMENTO** (CGNAT sem path privado/VPN correspondente), não regra de SG/NACL removida

**CloudTrail (7-14 dias, sa-east-1):**
- Nenhum evento `AuthorizeSecurityGroupEgress`, `RevokeSecurityGroupEgress`, `ModifySecurityGroupRules`, `CreateNetworkAclEntry`, `DeleteNetworkAclEntry`, `CreateRoute`, `ReplaceRoute`, `DeleteRoute`, `ModifyTransitGatewayVpcAttachment`, `EnableVgwRoutePropagation`, `DisableVgwRoutePropagation`, `DeleteVpnConnection`, `DetachVpnGateway` nos últimos 14 dias.
- Único evento de SG encontrado: `AuthorizeSecurityGroupIngress` em 2026-06-09 por leonardo.martins@corpay.com.br, em `sg-0650f74bdf18582c7` (SG diferente, regras de ingress 443/Zscaler) — **não relacionado**.

## Resolução

Diagnóstico entregue (read-only). Nenhuma alteração foi feita. Causas raiz identificadas:

1. **Mundiale**: regra de firewall/SG já existe e está correta no lado AWS — problema provavelmente externo (allowlist do parceiro / modo FTP passivo). Requer teste ativo de conectividade.
2. **Trabbe**: falta de rota válida para IP CGNAT 100.112.45.221 (VGW sem VPN connection ativa cobrindo esse range) + falta de regra de SG egress TCP/21. Requer ação de rede (criar/reativar VPN com range anunciado) antes de qualquer ajuste de SG.

## Comandos relevantes

```bash
# Localizar VPC pelas subnets
aws ec2 describe-subnets --filters "Name=cidr-block,Values=10.12.26.0/25,10.12.27.0/25,10.12.26.128/25,10.12.27.128/25"

# Route table efetiva
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-04b8a21f9ad99be66"

# Security Group do Databricks (egress)
aws ec2 describe-security-groups --group-ids sg-075d0a1313104ca2c

# VPN connections do VGW (retornou vazio -> rotas propagadas orfas)
aws ec2 describe-vpn-connections --filter "Name=vpn-gateway-id,Values=vgw-0b5ff8513545f7c5d"

# Flow logs (nao habilitados)
aws ec2 describe-flow-logs --filter "Name=resource-id,Values=vpc-04b8a21f9ad99be66"

# CloudTrail - eventos de mudanca de rede (exemplo)
aws cloudtrail lookup-events --start-time <7d-ago> --end-time <now> \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AuthorizeSecurityGroupEgress
```

## Lições aprendidas

- IPs CGNAT (100.64.0.0/10) nunca devem ser tratados como "vai pela rota default" — sempre verificar se há path privado (VPN/DX/TGW) anunciando o range específico antes de assumir conectividade.
- VGW attached sem VPN connection ativa pode deixar rotas propagadas "fantasmas" na route table (aparecem `active` mas sem destino físico) — gera falsa sensação de que existe um path privado.
- Flow Logs não habilitados nesta VPC = ponto cego total para diagnósticos de rede futuros. Deveria ser padrão em VPCs de produção (Operational Excellence / Security pillars).
- Antes de suspeitar de "regra removida", confirmar timestamp da descrição da regra existente no SG (muitas regras tem CHG number e data na descrição, o que ajuda a datar quando foi criada).

## Referências

- AWS VPN Gateway route propagation: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_VPN.html
- RFC 6598 (Shared Address Space / CGNAT 100.64.0.0/10): https://www.rfc-editor.org/rfc/rfc6598
- AWS VPC Reachability Analyzer: https://docs.aws.amazon.com/vpc/latest/reachability/
