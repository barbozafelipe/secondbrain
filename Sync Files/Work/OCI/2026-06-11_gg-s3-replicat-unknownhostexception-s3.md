---
tags: [oci, goldengate, networking, dns, diagnostico]
date: 2026-06-11
cluster/resource: gg-s3 (deployment display-name "gg-azure", compartimento Goldengate, sa-vinhedo-1)
status: diagnostico-entregue
---

## Contexto

Replicat `RVB01UDT` (e outro processo, bucket `flt-dna-l1-raw-cgmp4-ogg-...`) no Oracle GoldenGate
23.8.2.25.07 for Distributed Applications and Analytics (gg-s3) entrando em erro no FileFinalizeTask
ao verificar buckets S3 na AWS:

```
ERROR ... S3-00001 Failed to Verify S3 bucket [flt-dna-l1-raw-vb01-ogg-284309077449-sp5].
software.amazon.awssdk.core.exception.SdkClientException: Received an UnknownHostException
when attempting to interact with a service.
```

Ocorrências: 14/04/2026 (bucket vb01) e 10/06/2026 (bucket cgmp4) — dois processos, dois meses
diferentes, sugerindo problema intermitente de DNS, não config de bucket único.

## Diagnóstico

### Localização do serviço
- Compartimento **Goldengate**, deployment OCI GoldenGate `display-name: gg-azure`,
  `ogg-data.deployment-name: gg-s3`, `deployment-type: BIGDATA`,
  `ogg-version: oggbigdata:23.26.1.0.0_260208.2049_14210`
- PaaS gerenciado (não Compute/OKE), `is-public: false`, IP privado `10.17.70.38`
- Subnet `dna-subnet-private-goldengate` (10.17.70.0/25), VCN `Network-VCN` (compartimento Network)
- Achado paralelo: `is-storage-utilization-limit-exceeded: true` no deployment — risco de
  `STORAGE_FULL` se os Replicats continuarem ABENDED acumulando trail files

### Camada de rede OCI — tudo OK, sem drift
- Route table `dna-routetable-goldengate`: `0.0.0.0/0 -> NAT Gateway Network-NGW`
- NAT Gateway `Network-NGW`: `AVAILABLE`, `block-traffic: False`, IP público `193.123.108.73`
- Security List `dna-security-list-goldengate`: egress `0.0.0.0/0 : tcp/443` presente
- NSG da deployment: egress `0.0.0.0/0` todos protocolos liberado
- Sem Network Firewall no compartimento Network

### DNS — sem hijacking de amazonaws.com
- DNS Resolver `Network-VCN`: `rules: []`, `attached-views: []`, `endpoints: []` (resolver
  padrão OCI, sem customização)
- DHCP Options: `server-type: VcnLocalPlusInternet`, sem custom DNS servers
- 143 zonas DNS privadas no compartimento Network — nenhuma com `amazon`/`aws`/`s3` no nome
  (busca grep retornou vazio)

### Auditoria — sem mudanças recentes
- `audit event list` no compartimento Network (15/03 a 11/06/2026) filtrado por
  RouteTable/SecurityList/NatGateway/Resolver/DnsZone/NSG/DhcpOptions: **resultado vazio**
- Secret `gg-oracle-and-s3` (vault): versão única desde criação (26/08/2024), nunca rotacionado
- Secret `ACCESS-SECRET-KEY` (credenciais AWS): última rotação 07/08/2025 — anterior aos
  incidentes; além disso `UnknownHostException` não é erro de credencial

## Resolução

Diagnóstico de infraestrutura concluído sem encontrar drift ou bloqueio na camada OCI.
Causa mais provável está no runtime gerenciado do OGG BIGDATA Adapter (fora da
visibilidade do oci.cmd) ou na configuração do S3 Event Handler dos processos afetados.

Próximos passos (fora do escopo de infra OCI, encaminhar para time GoldenGate/DBA):
1. Comparar `gg.eventhandler.s3.region`/endpoint dos processos `RVB01UDT` e do processo
   do bucket `cgmp4` com um processo S3 saudável — buckets `*-sp5` sugerem `sa-east-1`,
   confirmar que o endpoint resolvido é `s3.sa-east-1.amazonaws.com` e não algo como
   `s3.sp5.amazonaws.com`
2. Testar DNS/conectividade a partir do Deployment Console do GoldenGate (sem SSH direto):
   `nslookup s3.sa-east-1.amazonaws.com` e
   `curl -v https://flt-dna-l1-raw-vb01-ogg-284309077449-sp5.s3.sa-east-1.amazonaws.com`
3. Se `s3.sa-east-1.amazonaws.com` (endpoint genérico) não resolver -> abrir SR com
   Oracle Support (problema de DNS na plataforma gerenciada do OGG)
4. Monitorar `is-storage-utilization-limit-exceeded` no deployment para evitar STORAGE_FULL

## Comandos relevantes

```bash
# Localizar deployments GoldenGate
oci.cmd goldengate deployment list --compartment-id ocid1.compartment.oc1..aaaaaaaaxdxecihux3zwtlukywup6tjui2tibmyqzuvbdtrgnfn3msbnwuwq --region sa-vinhedo-1 --all

# Detalhe do deployment gg-s3 (display-name gg-azure)
oci.cmd goldengate deployment get --deployment-id ocid1.goldengatedeployment.oc1.sa-vinhedo-1.amaaaaaa7kuxl5qaw3igleiapyhz7udmbknirm5ne5bq3ilo7ijbcugysffq --region sa-vinhedo-1

# Subnet, route table, security list
oci.cmd network subnet get --subnet-id ocid1.subnet.oc1.sa-vinhedo-1.aaaaaaaan2w7h7vgcbpmx4lrvheywphnkzmcfleqymfvr6vv4lzg4edkfmiq --region sa-vinhedo-1
oci.cmd network route-table get --rt-id ocid1.routetable.oc1.sa-vinhedo-1.aaaaaaaauyuehvxzfxrrvgalx3aj4zhremutolfr55622xr7n7rr2fhfie2q --region sa-vinhedo-1
oci.cmd network security-list get --security-list-id ocid1.securitylist.oc1.sa-vinhedo-1.aaaaaaaacxklzajlhlhes5xplybt54nn4aanqqiiadrajvt35kl4qfkkh3ga --region sa-vinhedo-1

# NSG da deployment
oci.cmd network nsg rules list --nsg-id ocid1.networksecuritygroup.oc1.sa-vinhedo-1.aaaaaaaamb3fgsk4446cgur6cgyqsm5rbd3oetrosmqrrcflkv3umqt3g3ea --region sa-vinhedo-1

# DNS Resolver e zonas privadas
oci.cmd dns resolver get --resolver-id ocid1.dnsresolver.oc1.sa-vinhedo-1.amaaaaaa7kuxl5qagmcfiklhstxxmos3u3ak2njowdcg4bssbar2kt4s6uza --scope PRIVATE --region sa-vinhedo-1
oci.cmd dns zone list --compartment-id ocid1.compartment.oc1..aaaaaaaaowpl4yy6bit2pitktbpcwez5ybcfrjd3ho35oscyuhz5iitsfcxq --scope PRIVATE --all --region sa-vinhedo-1

# NAT Gateway
oci.cmd network nat-gateway get --nat-gateway-id ocid1.natgateway.oc1.sa-vinhedo-1.aaaaaaaav263ipa3fevnxws5y7pfccc37xwotqlmdwzy6nszmgk24cfwtizq --region sa-vinhedo-1

# Auditoria de mudancas de rede (ultimos 3 meses)
oci.cmd audit event list --compartment-id ocid1.compartment.oc1..aaaaaaaaowpl4yy6bit2pitktbpcwez5ybcfrjd3ho35oscyuhz5iitsfcxq --start-time 2026-03-15T00:00:00Z --end-time 2026-06-11T23:59:59Z --region sa-vinhedo-1 --all
```

## Licoes aprendidas

- **Bug ambiental no OCI CLI desta maquina**: comandos `oci.cmd network ...` e
  `oci.cmd compute ...` (endpoint `iaas.<region>.oraclecloud.com`) falham com
  `SSLCertVerificationError: unable to get local issuer certificate` por causa do
  proxy TLS-inspecting Zscaler corporativo (root CA `Zscaler Root CA` instalada em
  `Cert:\LocalMachine\Root`). Comandos de outros servicos (ex: `oci.cmd goldengate ...`)
  funcionaram normalmente, o que mascarou o problema inicialmente.
  **Workaround**: exportar a Zscaler Root CA do Windows cert store, concatenar com o
  `cacert.pem` do certifi do OCI CLI, e setar `REQUESTS_CA_BUNDLE` apontando para o
  bundle combinado antes de rodar comandos `network`/`compute`.
  ```bash
  powershell.exe -Command "
    \$certs = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {\$_.Subject -match 'Zscaler'}
    foreach (\$c in \$certs) {
      \$bytes = \$c.Export('Cert')
      \$b64 = [System.Convert]::ToBase64String(\$bytes, 'InsertLineBreaks')
      \$pem = \"-----BEGIN CERTIFICATE-----\`n\$b64\`n-----END CERTIFICATE-----\"
      Add-Content -Path 'C:\Users\felipe.goncalves\AppData\Local\Temp\oci-ca\zscaler.pem' -Value \$pem
    }"
  cat "C:\Users\felipe.goncalves\lib\oracle-cli\Lib\site-packages\certifi\cacert.pem" \
      "C:\Users\felipe.goncalves\AppData\Local\Temp\oci-ca\zscaler.pem" \
      > "C:\Users\felipe.goncalves\AppData\Local\Temp\oci-ca\combined-ca.pem"
  export REQUESTS_CA_BUNDLE="C:\Users\felipe.goncalves\AppData\Local\Temp\oci-ca\combined-ca.pem"
  ```

- O deployment com `display-name: gg-azure` na verdade é o **gg-s3** internamente
  (`ogg-data.deployment-name: gg-s3`, `deployment-type: BIGDATA`) — nomenclatura
  enganosa no console, atenção ao filtrar por nome.

- `UnknownHostException` em SDK AWS rodando em OCI nao é necessariamente problema de
  rede OCI — quando toda a stack de rede (route table, NAT, security list, NSG, DNS
  resolver/zonas) está limpa e sem drift, a investigação deve migrar para a camada de
  aplicacao (configuracao do handler/endpoint) ou para o runtime gerenciado (Oracle-side),
  via Oracle Support.

## Referencias

- OCI Architecture Center - Networking (route tables, NAT Gateway, Service Gateway)
- OCI DNS - Private Views and Resolvers
- [[project_oci_iam_groups]] - layout de grupos IAM Corpay
