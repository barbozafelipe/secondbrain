---
tags: [azure, networking, bgp, expressroute, firewall, troubleshooting]
criado: 2026-05-26
---

# Entendendo Roteamento Azure: BGP, AS, ExpressRoute e Firewall

## 🗺️ O Cenário Geral (A Analogia)

Imagina que a rede da empresa é uma **cidade** com vários bairros e estradas. Cada bairro tem um **porteiro** (firewall) que decide quem entra e quem sai.

| Conceito Técnico | Analogia |
|---|---|
| Sua máquina na VPN (`10.80.8.x`) | Você, saindo de casa |
| Firewall On-Premises (`10.0.128.249`) | Portaria do condomínio (datacenter SP4) |
| ExpressRoute | Estrada privada exclusiva entre o condomínio e o shopping (Azure) |
| Azure Firewall (`10.17.128.4`) | Portaria do shopping (Azure) |
| Banco PostgreSQL (`10.17.205.164`) | Loja dentro do shopping |

---

## 🔤 O que é BGP e AS?

### AS (Autonomous System) — O "CEP" de cada rede
Cada rede grande tem um número de identificação mundial chamado **AS Number**. Pense como o CEP de um bairro:

- **AS 65040** = Rede da Fleet (o firewall do datacenter)
- **AS 12076** = Rede da Microsoft/Azure (número público oficial da Microsoft)
- **AS 65030** = Provavelmente outro equipamento da infra

### BGP (Border Gateway Protocol) — O "Waze das Redes"
O BGP é o protocolo que os roteadores usam para **trocar informações de rotas entre si**. É como se cada porteiro dissesse pro outro:

> *"Ei, se alguém quiser chegar na rede `10.80.0.0/18` (VPN dos funcionários), manda pra mim que eu sei o caminho!"*

No caso prático:
- O Firewall da Fleet (`10.0.128.249`, AS `65040`) fala pro Azure via BGP: *"Eu conheço a rede `10.80.0.0/18`, manda pra mim!"*
- O Azure (AS `12076`) aprende isso e anota na sua tabela de rotas do ExpressRoute

**É por isso que na tabela de rotas do ExpressRoute aparece:**
```
10.80.0.0/18  →  10.0.128.249  (AS 65040)
```
Isso significa: *"Para mandar pacotes de volta para alguém em 10.80.x.x, o Azure sabe que tem que devolver pro firewall 10.0.128.249 via ExpressRoute."*

---

## 🛣️ O Caminho Completo (Ida e Volta)

### Ida (funciona ✅)
```
Você (10.80.8.x)
  │
  ▼
VPN (túnel criptografado)
  │
  ▼
Firewall On-Prem SP4 (10.0.128.249)  ← entra por x1, sai por port15
  │
  ▼
ExpressRoute (estrada privada SP4 → Azure)
  │
  ▼
Azure ExpressRoute Gateway
  │
  ▼
Azure Firewall (10.17.128.4)  ← Regra "Allow" na policy
  │
  ▼
Recurso de destino (ex: PostgreSQL)
```

### Volta (caminho esperado)
```
Recurso de destino responde
  │
  ▼
Route Table da Subnet (UDR): 0.0.0.0/0 → 10.17.128.4
  │
  ▼
Azure Firewall (10.17.128.4)  ← stateful, deveria lembrar da ida
  │
  ▼
ExpressRoute Gateway
  │
  ▼
ExpressRoute (estrada privada Azure → SP4)
  │
  ▼
Firewall On-Prem SP4 (10.0.128.249)
  │
  ▼
VPN → Você
```

---

## 🔥 Azure Firewall: Stateful e Rule Collections

O Azure Firewall é **stateful** — ele mantém uma "memória" de cada conexão. Quando um pacote de ida (SYN) passa, ele cria uma entrada dizendo:

> *"Conexão aberta: origem:porta → destino:porta. Quando a resposta vier, deixa passar."*

### Hierarquia de Regras
```
Firewall Policy
  └── Rule Collection Group (prioridade X)
  │     └── Rule Collection
  │           └── Regras individuais
  │
  └── Rule Collection Group (prioridade Y)
        └── ...
```

As regras são avaliadas **por prioridade** (menor número = avaliado primeiro). Se existe um DENY com prioridade mais alta que bate antes de um Allow, o pacote é dropado.

---

## 🔄 Roteamento Assimétrico

**O que é:** Quando o pacote de ida faz um caminho e o de volta faz outro caminho diferente.

**Analogia:** Você manda uma carta pelo Correio (datacenter SP4), mas a resposta volta pelo FedEx (datacenter DR). O FedEx não sabe que você mandou uma carta e joga fora.

**Como diagnosticar:** Fazer `tcpdump`/`diagnose sniffer packet` nos dois caminhos possíveis (SP4 e DR). Se a resposta não aparece em nenhum, o problema é antes — dentro do Azure.

---

## 🛠️ Ferramentas de Troubleshooting

| Ferramenta | Onde usar | O que mostra |
|---|---|---|
| `Test-NetConnection -Port` | PowerShell (Windows) | Se a porta TCP está acessível |
| `telnet IP PORTA` | PowerShell/CMD | Teste de conexão TCP direto |
| `tracert IP` | CMD | Caminho que o pacote faz (cada "salto") |
| `nmap -Pn --traceroute -p PORTA IP` | nmap (instalar) | Traceroute pela porta específica |
| `diagnose sniffer packet` | Firewall FortiGate (CLI) | Dump de pacotes em tempo real |
| Azure Firewall Logs | Portal Azure (Log Analytics) | Regras que deram Allow/Deny |
