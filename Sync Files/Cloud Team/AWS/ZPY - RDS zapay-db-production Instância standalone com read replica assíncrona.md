---
tags: [aws, zapay, rds, postgresql, diagnostico]
date: 2026-07-07
account: "071032557399 (zapay prod, sa-east-1)"
cluster: zapay-db-production
status: resolvido
---

## Contexto

Solicitada investigação read-only sobre um suposto "cluster Aurora zapay-db-production" na conta Zapay prod (071032557399, sa-east-1), assumindo topologia Aurora (DBClusterMembers, writer/reader endpoints, storage replicado em 3 AZs).

## Diagnóstico

`aws rds describe-db-clusters --db-cluster-identifier zapay-db-production --region sa-east-1 --profile zapay` retornou `DBClusterNotFoundFault`. Idem para `describe-db-cluster-endpoints`.

Investigação via `describe-db-instances` confirmou: **não existe Aurora Cluster**. `zapay-db-production` é uma instância RDS PostgreSQL clássica (engine `postgres`, não `aurora-postgresql`), engine version `16.14`, classe `db.m6g.4xlarge`, na AZ `sa-east-1c`. Possui uma read replica assíncrona `zapay-db-production-replica` (`db.m6g.2xlarge`, AZ `sa-east-1a`).

Nenhuma das duas instâncias tem `SecondaryAvailabilityZone` — ou seja, `MultiAZ: false` em ambas, confirmado também pelo campo direto. Não há standby síncrono de failover automático — a resiliência de leitura existe via read replica cross-AZ, mas não há failover automático RDS Multi-AZ configurado.

DBSubnetGroup `vpc_eks_private` (VPC `vpc-0e1fc1d6b0cbbaa6d`) cobre 3 subnets em 3 AZs: `sa-east-1a`, `sa-east-1b`, `sa-east-1c`. Apenas `sa-east-1a` (replica) e `sa-east-1c` (primária) têm instâncias ativas; `sa-east-1b` está no subnet group mas sem nenhuma instância.

Sem Aurora Cluster, não há endpoints WRITER/READER gerenciados — cada instância expõe seu próprio endpoint fixo:
- `zapay-db-production.ck3lf3mk2j9b.sa-east-1.rds.amazonaws.com:5432` (primária)
- `zapay-db-production-replica.ck3lf3mk2j9b.sa-east-1.rds.amazonaws.com:5432` (replica)

Sem balanceamento automático entre réplicas (diferente do Aurora Reader Endpoint).

## Resolução

Diagnóstico entregue como esclarecimento de topologia — não é um bug, é uma premissa incorreta na demanda original (assumia Aurora onde há RDS instance-based). Nenhuma ação corretiva necessária; apenas correção de entendimento para decisões futuras (ex: propostas de arquitetura envolvendo esse banco devem considerar RDS clássico, não Aurora).

Detalhes adicionais coletados:
- StorageEncrypted: `true` em ambas, KMS key `132c872e-f0de-4525-9cf4-45da92757476`
- DeletionProtection: `true` em ambas
- PubliclyAccessible: `false` em ambas
- BackupRetentionPeriod: `7` dias na primária, `0` na replica (esperado — replicas não fazem backup automático próprio)
- SecurityGroup: `sg-082f4664365257de0` em ambas

## Comandos relevantes

```bash
aws sts get-caller-identity --profile zapay

aws rds describe-db-clusters --db-cluster-identifier zapay-db-production --region sa-east-1 --profile zapay
# -> DBClusterNotFoundFault (confirma que não é Aurora)

aws rds describe-db-instances --db-instance-identifier zapay-db-production --region sa-east-1 --profile zapay
aws rds describe-db-instances --db-instance-identifier zapay-db-production-replica --region sa-east-1 --profile zapay

aws rds describe-db-subnet-groups --db-subnet-group-name vpc_eks_private --region sa-east-1 --profile zapay

aws rds describe-db-cluster-endpoints --db-cluster-identifier zapay-db-production --region sa-east-1 --profile zapay
# -> DBClusterNotFoundFault (confirma ausência de cluster endpoints)
```

## Lições aprendidas

- O baseline do agent já registrava "RDS (PostgreSQL, sem Aurora)" para zapay-db-production — este diagnóstico confirma e reforça essa nota via evidência direta de CLI.
- Nunca assumir topologia (Aurora vs RDS clássico) a partir do nome do recurso ("cluster" no nome de negócio não implica Aurora DB Cluster técnico). Sempre validar via `describe-db-clusters` antes de reportar campos específicos de Aurora (DBClusterMembers, cluster endpoints writer/reader).
- Em RDS instance-based, resiliência multi-AZ real depende do campo `MultiAZ` e `SecondaryAvailabilityZone` da própria instância — read replica cross-AZ não é o mesmo que Multi-AZ synchronous standby (sem failover automático).

## Referências

- AWS RDS API: `describe-db-clusters`, `describe-db-instances`, `describe-db-subnet-groups`, `describe-db-cluster-endpoints`
- Memória do agent: baseline inventário Zapay prod (snapshot 2026-06-16) — seção RDS já indicava "sem Aurora" para zapay-db-production
