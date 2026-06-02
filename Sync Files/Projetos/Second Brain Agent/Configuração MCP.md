---
tags: [projeto, ia, mcp, configuração, tutorial]
---

# Configuração MCP — Second Brain Agent

> Passo a passo para configurar os MCPs no Claude Desktop.

---

## Pré-requisitos

- [Claude Desktop](https://claude.ai/download) instalado
- [Node.js](https://nodejs.org/) instalado (v18+) — necessário para rodar os servidores MCP
- Vault Obsidian no caminho: `C:\GitHub\secondbrain`

---

## Fase 1 — MCP Filesystem (Obsidian)

> Esse é o primeiro MCP. Ele dá ao Claude acesso de **leitura e escrita** ao seu vault.

### 1. Abrir o arquivo de configuração do Claude Desktop

O arquivo fica em:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Pode abrir pelo terminal:

```powershell
notepad "$env:APPDATA\Claude\claude_desktop_config.json"
```

### 2. Adicionar o MCP Filesystem

Cole ou edite o JSON para ficar assim:

```json
{
  "mcpServers": {
    "obsidian-vault": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\GitHub\\secondbrain\\Sync Files"
      ]
    }
  }
}
```

> [!warning] Caminho com barras duplas
> No JSON do Windows, use `\\` em vez de `\` nos caminhos.

> [!tip] Escopo do acesso
> O MCP só tem acesso ao diretório que você apontar. Aqui estamos apontando para `Sync Files` que é onde ficam as notas. O Claude **não** terá acesso a nada fora dessa pasta.

### 3. Reiniciar o Claude Desktop

Feche e abra o Claude Desktop. Quando abrir, você deve ver o ícone de MCP (🔌) no canto inferior da janela de chat.

### 4. Testar

Abra um chat novo e pergunte:

> "Liste os arquivos que estão na pasta Work/Reuniões semanais/"

Se ele listar as notas de reunião, tá funcionando. ✅

---

## Fase 2 — MCP Google Calendar (futuro)

> Instalar quando chegar na Fase 3 do roadmap.

```json
{
  "mcpServers": {
    "obsidian-vault": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\GitHub\\secondbrain\\Sync Files"
      ]
    },
    "google-calendar": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-google-calendar"
      ],
      "env": {
        "GOOGLE_CLIENT_ID": "<seu-client-id>",
        "GOOGLE_CLIENT_SECRET": "<seu-client-secret>",
        "GOOGLE_REDIRECT_URI": "http://localhost:3000/callback"
      }
    }
  }
}
```

> [!note] Credenciais do Google
> Vai precisar criar um projeto no Google Cloud Console e gerar credenciais OAuth2. Tutorial completo quando chegar nessa fase.

---

## Fase 3 — MCP Gmail (futuro)

> Instalar quando chegar na Fase 4 do roadmap. Usa as mesmas credenciais Google.

---

## Troubleshooting

| Problema | Solução |
|---|---|
| Ícone de MCP não aparece | Verifique se o JSON está válido (sem vírgula sobrando). Reinicie o Claude Desktop. |
| "Permission denied" | Verifique se o caminho do vault está correto e acessível. |
| "npx not found" | Instale o Node.js e verifique se `npx` está no PATH (`npx --version`). |
| MCP conecta mas não encontra arquivos | Verifique se o caminho aponta para `Sync Files` e não para a raiz do vault. |

---

## Referências

- [MCP Filesystem Server](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem)
- [Claude Desktop + MCP Quickstart](https://modelcontextprotocol.io/quickstart/user)
- [[Second Brain Agent]] — nota principal do projeto
- [[Prompt — Second Brain Agent]] — prompt do agente
