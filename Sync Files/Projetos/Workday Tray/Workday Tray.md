---
tipo: projeto
criado: 2026-07-29
tags: [powershell, windows, produtividade, automacao, ferramenta-pessoal]
status: ativo
fonte: conversa-claude
---

# Workday Tray

> **TL;DR:** Dois ícones na bandeja do Windows que mostram, ao vivo, **a % da jornada de trabalho concluída** e **quanto dinheiro eu já ganhei no dia**. PowerShell + WinForms puro, sem instalar nada. Os scripts prontos estão nesta mesma pasta — para replicar em outra máquina, copiar os dois arquivos e seguir a seção "Instalação".

## O que faz

| Ícone | Mostra | Tooltip |
|---|---|---|
| **1** | Número = **% da jornada** (0-100) | `69% - 6h16 feitas, faltam 2h44` |
| **2** | Número = **reais acumulados** no dia | `R$ 148,83 de R$ 213,75 (69%)` |

Os dois têm uma barrinha de progresso no rodapé (azul → verde conforme o dia avança) e se adaptam ao tema claro/escuro da barra de tarefas. Existe ainda uma **janela flutuante opcional** com o valor por extenso e centavos correndo — desligada por padrão.

**Cálculo do dinheiro:** `valor_do_dia = salário_líquido_mensal ÷ dias_úteis_reais_do_mês`, distribuído linearmente entre 09:00 e 18:00.

## Arquivos

| Arquivo | Função |
|---|---|
| `workday-tray.ps1` | O app inteiro (497 linhas). Configuração no topo. |
| `start-workday-tray.vbs` | Launcher que roda o PowerShell **sem piscar janela de console**. |

> Local de execução na máquina atual: `C:\Users\felipe.goncalves\WorkdayTray\`. Os arquivos aqui no vault são a cópia versionada — **a fonte de verdade para replicação**.

## Instalação em outra máquina

1. Criar `C:\Users\<usuario>\WorkdayTray\` e copiar os dois arquivos desta pasta para lá.
2. Abrir `workday-tray.ps1` e ajustar o bloco `CONFIGURACAO` (ver abaixo) — no mínimo `$NetMonthly` e `$ExtraHolidays`.
3. Testar: dar duplo clique em `start-workday-tray.vbs`. Os ícones devem aparecer na bandeja em ~3s.
4. **Iniciar com o Windows**: botão direito no ícone → "Iniciar com o Windows". Isso cria um atalho em `shell:startup` apontando para `wscript.exe "<caminho>\start-workday-tray.vbs"`.

Não precisa instalar nada — PowerShell 5.1 e .NET Framework já vêm no Windows. Não precisa de admin.

### Se os ícones não aparecerem na barra
O Windows 11 joga **todo ícone novo para dentro do `^` (ícones ocultos)** por padrão. Não é bug do script. Para fixar ao lado do relógio: abrir o `^` e **arrastar o ícone para fora**, ou Configurações → Personalização → Barra de tarefas → "Outros ícones da bandeja do sistema" → ligar `powershell.exe`.

## Configuração (topo do `.ps1`)

```powershell
# --- jornada ---
$WorkStart  = '09:00'
$WorkEnd    = '18:00'
$WorkDays   = @('Monday','Tuesday','Wednesday','Thursday','Friday')
$RefreshSec = 1          # atualizacao em segundos

# --- dinheiro ---
$NetMonthly    = 4702.43            # salario LIQUIDO mensal (ponto decimal)
$ExtraHolidays = @('25/01','09/07') # feriados municipais/estaduais 'dd/MM'
$CarnivalOff   = $true              # carnaval conta como feriado?

# --- icones ---
$ShowPctIcon   = $true   # icone da porcentagem
$ShowMoneyIcon = $true   # icone dos reais

# --- widget flutuante ---
$WidgetVisible = $false  # comeca visivel?
$WidgetOpacity = 0.92
$NotifyEnd     = $true   # balao ao completar 100%
```

`$ExtraHolidays` atual = São Paulo capital (25/01 aniversário da cidade, 09/07 Revolução Constitucionalista estadual). Trocar conforme a cidade.

Depois de editar: botão direito no ícone → **Sair**, e rodar o `.vbs` de novo.

## Controles

| Ação | Como |
|---|---|
| Ver detalhes | Passar o mouse em qualquer ícone |
| Mostrar/ocultar a janela de R$ | **Duplo clique** em qualquer ícone, ou menu → "Mostrar widget de R$" |
| Fechar a janela flutuante | **Esc** com ela em foco, ou botão direito nela → menu |
| Mover a janela | Arrastar. A posição é salva em `widget.pos` e restaurada no próximo boot |
| Editar config | Menu → "Editar configuracao..." |
| Encerrar | Menu → "Sair" |

## Como funciona por dentro

**Feriados** — os fixos são tabela; os móveis (Sexta-feira Santa, Corpus Christi, Carnaval) são **calculados a partir da Páscoa** pelo algoritmo de Meeus/Butcher em `Get-Easter`. Por isso funciona em qualquer ano sem manutenção. Validado contra o calendário de 2026: Páscoa 05/04, Sexta-feira Santa 03/04, Carnaval 16-17/02, Corpus Christi 04/06.

**Dias úteis** — `Get-BusinessDaysInMonth` varre o mês corrente contando dias da semana que não são feriado. Isso faz o valor diário **variar de mês a mês** (18 dias em fevereiro/2026 → 23 em julho), mantendo o total mensal correto. Foi decisão consciente: divisor fixo daria valor diário estável, mas o acumulado não bateria com o contracheque.

**Desenho do ícone** — bitmap 32×32 desenhado com `System.Drawing`, convertido com `GetHicon()` → `Icon.FromHandle().Clone()` → `DestroyIcon()` (o `DestroyIcon` é obrigatório, senão vaza handle a cada refresh).

**Tema** — lê `HKCU:\...\Themes\Personalize\SystemUsesLightTheme` a cada render para decidir texto claro ou escuro.

**Instância única** — mutex `Local\WorkdayTrayIcon`. Segunda instância sai na hora.

**Eficiência** — o timer roda a cada 1s (para os centavos da janela), mas cada ícone só é **redesenhado quando o texto muda**: a % muda ~a cada 5min, os reais ~a cada 2,5min.

## Armadilhas resolvidas (registrar para não repetir)

**1. Texto do ícone cortado / quebrando linha.** A primeira versão usava tamanhos de fonte fixos por número de dígitos. `100` não cabia e quebrava em duas linhas. **Solução:** `Draw-FitText` mede a string com `MeasureString` + `StringFormat.GenericTypographic` (sem o padding extra do formato padrão) + flag `NoWrap`, e desce o corpo da fonte de 34px até achar o maior que cabe de fato. Nunca mais chutar tamanho de fonte.

**2. O anel circular comia o espaço do número.** Versão inicial desenhava um anel de progresso de 3,5px em volta — sobrava pouco miolo e o número ficava minúsculo. **Solução:** trocar o anel por uma **barra de 4px no rodapé**, que custa só 4px de altura e libera 27 dos 32px para o número.

**3. Janela flutuante impossível de fechar.** Foi criada `FormBorderStyle=None`, sem botão de fechar e **sem menu de contexto** — ficou presa na tela. **Solução:** `ContextMenuStrip` na janela + `KeyPreview` com `Esc` para ocultar. Lição: form sem borda **precisa** de pelo menos duas saídas.

**4. DPI.** A tela é 2560×1440 com escala de 133%. Processos DPI-unaware enxergam 1920×1080 virtualizado. Isso fez capturas de tela e cliques automatizados errarem o alvo durante o desenvolvimento. Se for depurar posição de janela, **confirmar em que espaço de coordenadas cada processo está**.

**5. Auto-kill ao reiniciar o app.** Um comando que matava processos filtrando por `CommandLine -like '*workday-tray.ps1*'` casava com o **próprio processo PowerShell que rodava o comando** (o texto do comando contém a string) e se matava, retornando exit 255 sem output. **Solução:** sempre excluir `$PID` do filtro.

## Verificação rápida (diagnóstico)

```powershell
# o app esta rodando?
$pat = '*' + 'workday' + '-tray.ps' + '1*'   # quebrado para nao casar consigo mesmo
Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" |
  Where-Object { $_.CommandLine -like $pat -and $_.ProcessId -ne $PID } |
  Select-Object ProcessId, CreationDate

# subir capturando erro (o launcher .vbs engole stderr)
Start-Process powershell.exe -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',`
  'C:\Users\<usuario>\WorkdayTray\workday-tray.ps1' `
  -RedirectStandardError "$env:TEMP\wt-err.txt" -WindowStyle Hidden
```

## Ideias não implementadas

- **Atalho global** (ex.: `Ctrl+Alt+H`) para sumir com a janela flutuante numa chamada do Teams. Exige `RegisterHotKey` via `NativeWindow` em C# — dá para fazer, ficou de fora por simplicidade.
- **Integração com ActivityWatch** (já instalado na máquina, expõe API local) para **pausar a contagem quando a máquina fica ociosa ou bloqueada**. Hoje o cálculo é relógio corrido: se eu sair mais cedo, ele não sabe. Isso transformaria o número em tempo real de trabalho.
- Almoço: hoje **não é descontado** de propósito. Como o valor do dia é fixo, descontar não muda o total, só a curva — e meu horário de almoço varia, então uma janela fixa erraria justamente nas horas em que eu olho. Linear é sempre "certo o bastante".

---
_Criado em 2026-07-29. Relacionado: [[Financeiro]] (o `$NetMonthly` vem de lá), [[Setup]]._
