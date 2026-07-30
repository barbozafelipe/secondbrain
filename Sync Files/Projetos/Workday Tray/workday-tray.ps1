# =====================================================================
#  Workday Tray - progresso da jornada + ganho acumulado do dia
# =====================================================================

# ======================= CONFIGURACAO ================================

# --- jornada ---
$WorkStart  = '09:00'
$WorkEnd    = '18:00'
$WorkDays   = @('Monday','Tuesday','Wednesday','Thursday','Friday')
$RefreshSec = 1          # atualizacao do widget de R$ (em segundos)

# --- dinheiro ---------------------------------------------------------
#  Salario mensal LIQUIDO (o que cai na conta).
#  Use ponto como separador decimal.
$NetMonthly = 4702.43

#  Feriados municipais/estaduais alem dos nacionais, formato 'dd/MM'.
#  Sao Paulo capital: 25/01 aniversario da cidade
#                     09/07 Revolucao Constitucionalista (estadual SP)
$ExtraHolidays  = @('25/01','09/07')

#  Carnaval (segunda e terca) conta como feriado? (nao e feriado
#  nacional por lei, mas quase todo mundo folga)
$CarnivalOff    = $true

# --- icones da bandeja ---
#  Sao dois icones independentes: um com o % da jornada, outro com os
#  reais acumulados. Ambos com a barrinha de progresso no rodape.
$ShowPctIcon    = $true
$ShowMoneyIcon  = $true

# --- widget flutuante (opcional; o principal sao os icones da bandeja) ---
#  Para chamar/dispensar: duplo clique no icone da bandeja, ou botao
#  direito no icone -> "Mostrar widget de R$". Com ela em foco, Esc fecha.
$WidgetVisible  = $false   # comeca visivel?
$WidgetOpacity  = 0.92
$NotifyEnd      = $true    # balao ao completar 100%
# =====================================================================

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WdTrayNative {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern bool DestroyIcon(IntPtr handle);
}
"@

# --- instancia unica ---
$createdNew = $false
$script:Mutex = New-Object System.Threading.Mutex($true, 'Local\WorkdayTrayIcon', [ref]$createdNew)
if (-not $createdNew) { exit }

$ScriptPath   = $MyInvocation.MyCommand.Path
$ScriptDir    = Split-Path $ScriptPath
$LauncherPath = Join-Path $ScriptDir 'start-workday-tray.vbs'
$PosFile      = Join-Path $ScriptDir 'widget.pos'
$StartupLink  = Join-Path ([Environment]::GetFolderPath('Startup')) 'Workday Tray.lnk'
$PtBr         = [System.Globalization.CultureInfo]::GetCultureInfo('pt-BR')

# ---------------------------------------------------------------------
#  Feriados e dias uteis
# ---------------------------------------------------------------------
function Get-Easter([int]$year) {
    $a = $year % 19
    $b = [Math]::Floor($year / 100); $c = $year % 100
    $d = [Math]::Floor($b / 4);      $e = $b % 4
    $f = [Math]::Floor(($b + 8) / 25)
    $g = [Math]::Floor(($b - $f + 1) / 3)
    $h = (19*$a + $b - $d - $g + 15) % 30
    $i = [Math]::Floor($c / 4);      $k = $c % 4
    $l = (32 + 2*$e + 2*$i - $h - $k) % 7
    $m = [Math]::Floor(($a + 11*$h + 22*$l) / 451)
    $mo = [Math]::Floor(($h + $l - 7*$m + 114) / 31)
    $dy = (($h + $l - 7*$m + 114) % 31) + 1
    Get-Date -Year $year -Month $mo -Day $dy -Hour 0 -Minute 0 -Second 0
}

function Get-Holidays([int]$year) {
    $list = New-Object System.Collections.Generic.List[datetime]
    foreach ($d in '01/01','21/04','01/05','07/09','12/10','02/11','15/11','20/11','25/12') {
        $p = $d.Split('/')
        $list.Add((Get-Date -Year $year -Month ([int]$p[1]) -Day ([int]$p[0]) -Hour 0 -Minute 0 -Second 0).Date)
    }
    foreach ($d in $ExtraHolidays) {
        $p = $d.Split('/')
        $list.Add((Get-Date -Year $year -Month ([int]$p[1]) -Day ([int]$p[0]) -Hour 0 -Minute 0 -Second 0).Date)
    }
    $easter = (Get-Easter $year).Date
    $list.Add($easter.AddDays(-2))    # Sexta-feira Santa
    $list.Add($easter.AddDays(60))    # Corpus Christi
    if ($CarnivalOff) {
        $list.Add($easter.AddDays(-48))   # segunda de carnaval
        $list.Add($easter.AddDays(-47))   # terca de carnaval
    }
    $list | Sort-Object -Unique
}

$script:HolidayCache = @{}
function Test-Holiday([datetime]$date) {
    $y = $date.Year
    if (-not $script:HolidayCache.ContainsKey($y)) {
        $script:HolidayCache[$y] = @(Get-Holidays $y | ForEach-Object { $_.Date })
    }
    $script:HolidayCache[$y] -contains $date.Date
}

function Test-WorkDay([datetime]$date) {
    ($WorkDays -contains $date.DayOfWeek.ToString()) -and -not (Test-Holiday $date)
}

# dias uteis do mes corrente, descontando feriados
function Get-BusinessDaysInMonth([datetime]$ref) {
    $first = Get-Date -Year $ref.Year -Month $ref.Month -Day 1 -Hour 0 -Minute 0 -Second 0
    $n = 0
    for ($d = $first; $d.Month -eq $ref.Month; $d = $d.AddDays(1)) {
        if (Test-WorkDay $d) { $n++ }
    }
    if ($n -lt 1) { 1 } else { $n }
}

# ---------------------------------------------------------------------
#  Jornada
# ---------------------------------------------------------------------
function ConvertTo-TodayTime([string]$hhmm) {
    $p = $hhmm.Split(':')
    (Get-Date).Date.AddHours([int]$p[0]).AddMinutes([int]$p[1])
}

function Get-WorkdayState {
    $now   = Get-Date
    $start = ConvertTo-TodayTime $WorkStart
    $end   = ConvertTo-TodayTime $WorkEnd
    $total = $end - $start

    # valor do dia = liquido mensal / dias uteis reais do mes
    $dayValue = 0.0
    if ($NetMonthly -gt 0) {
        $dayValue = [double]$NetMonthly / (Get-BusinessDaysInMonth $now)
    }

    if (-not (Test-WorkDay $now)) {
        $why = if (Test-Holiday $now) { 'feriado' } else { 'fim de semana' }
        return [pscustomobject]@{
            State='off'; Why=$why; Pct=0; Elapsed=[TimeSpan]::Zero; Remaining=[TimeSpan]::Zero
            Earned=0.0; DayValue=$dayValue; Start=$start; End=$end
        }
    }

    if ($now -lt $start) {
        return [pscustomobject]@{
            State='before'; Why=''; Pct=0; Elapsed=[TimeSpan]::Zero; Remaining=$total
            Earned=0.0; DayValue=$dayValue; Start=$start; End=$end
        }
    }
    if ($now -ge $end) {
        return [pscustomobject]@{
            State='after'; Why=''; Pct=100; Elapsed=$total; Remaining=[TimeSpan]::Zero
            Earned=$dayValue; DayValue=$dayValue; Start=$start; End=$end
        }
    }

    $elapsed = $now - $start
    $frac    = $elapsed.TotalMinutes / $total.TotalMinutes
    [pscustomobject]@{
        State='during'; Why=''; Pct=($frac * 100); Elapsed=$elapsed; Remaining=($total - $elapsed)
        Earned=($dayValue * $frac); DayValue=$dayValue; Start=$start; End=$end
    }
}

function Format-Span([TimeSpan]$ts) { '{0}h{1:00}' -f [int]$ts.TotalHours, $ts.Minutes }
function Format-Money([double]$v)   { $v.ToString('C2', $PtBr) }

# ---------------------------------------------------------------------
#  Icone da bandeja
# ---------------------------------------------------------------------
function Test-LightTaskbar {
    try {
        $v = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' `
                                   -Name 'SystemUsesLightTheme' -ErrorAction Stop
        return ($v -eq 1)
    } catch { return $false }
}

function Get-AccentColor([double]$pct, [string]$state) {
    if ($state -eq 'off')   { return [System.Drawing.Color]::FromArgb(255,150,150,150) }
    if ($state -eq 'after') { return [System.Drawing.Color]::FromArgb(255, 76,205,120) }
    $t = [Math]::Max(0.0, [Math]::Min(1.0, $pct / 100.0))
    [System.Drawing.Color]::FromArgb(255, [int](77 + $t*(76-77)), [int](166 + $t*(205-166)), [int](255 + $t*(120-255)))
}

# Desenha o texto no MAIOR corpo de fonte que couber no espaco disponivel.
function Draw-FitText {
    param(
        [System.Drawing.Graphics]$g, [string]$label,
        [single]$cx, [single]$cy, [single]$availW, [single]$availH,
        [System.Drawing.Color]$color, [int]$maxPx = 34
    )
    $fmt = [System.Drawing.StringFormat]::GenericTypographic.Clone()
    $fmt.FormatFlags = [System.Drawing.StringFormatFlags]::NoWrap -bor `
                       [System.Drawing.StringFormatFlags]::NoClip
    $font = $null; $sz = $null
    for ($px = $maxPx; $px -ge 7; $px--) {
        $f = New-Object System.Drawing.Font 'Segoe UI', $px, `
                 ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
        $m = $g.MeasureString($label, $f, [System.Drawing.PointF]::Empty, $fmt)
        if ($m.Width -le $availW -and $m.Height -le $availH) { $font = $f; $sz = $m; break }
        $f.Dispose()
    }
    if (-not $font) { $fmt.Dispose(); return }
    $brush = New-Object System.Drawing.SolidBrush $color
    $g.DrawString($label, $font, $brush, ($cx - $sz.Width/2), ($cy - $sz.Height/2), $fmt)
    $brush.Dispose(); $font.Dispose(); $fmt.Dispose()
}

# $label = o que vai escrito no icone (reais acumulados); a barra do
# rodape continua representando o % da jornada.
function New-TrayIcon([double]$pct, [string]$state, [string]$label) {
    $size = 32
    $bmp  = New-Object System.Drawing.Bitmap $size, $size
    $g    = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.Clear([System.Drawing.Color]::Transparent)

    if (Test-LightTaskbar) {
        $textColor  = [System.Drawing.Color]::FromArgb(255, 28, 28, 28)
        $trackColor = [System.Drawing.Color]::FromArgb(70, 0, 0, 0)
    } else {
        $textColor  = [System.Drawing.Color]::FromArgb(255,242,242,242)
        $trackColor = [System.Drawing.Color]::FromArgb(80,255,255,255)
    }
    $accent = Get-AccentColor $pct $state

    Draw-FitText $g $label ($size/2) 13.5 $size 27 $textColor

    $barY = 28; $barH = 4; $barX = 1; $barW = $size - 2
    $bt = New-Object System.Drawing.SolidBrush $trackColor
    $g.FillRectangle($bt, $barX, $barY, $barW, $barH); $bt.Dispose()
    if ($pct -gt 0) {
        $fill = [float]($barW * [Math]::Min(100, $pct) / 100)
        if ($fill -lt 2) { $fill = 2 }
        $ba = New-Object System.Drawing.SolidBrush $accent
        $g.FillRectangle($ba, $barX, $barY, $fill, $barH); $ba.Dispose()
    }
    $g.Dispose()

    $hIcon = $bmp.GetHicon()
    $icon  = [System.Drawing.Icon]::FromHandle($hIcon).Clone()
    [void][WdTrayNative]::DestroyIcon($hIcon)
    $bmp.Dispose()
    return $icon
}

# ---------------------------------------------------------------------
#  Inicializar com o Windows
# ---------------------------------------------------------------------
function Test-Autostart { Test-Path $StartupLink }
function Set-Autostart([bool]$enable) {
    if ($enable) {
        $ws = New-Object -ComObject WScript.Shell
        $sc = $ws.CreateShortcut($StartupLink)
        $sc.TargetPath       = "$env:SystemRoot\System32\wscript.exe"
        $sc.Arguments        = '"' + $LauncherPath + '"'
        $sc.WorkingDirectory = $ScriptDir
        $sc.Description      = 'Workday Tray - progresso da jornada'
        $sc.Save()
    } elseif (Test-Path $StartupLink) {
        Remove-Item $StartupLink -Force
    }
}

# ---------------------------------------------------------------------
#  Widget flutuante de R$
# ---------------------------------------------------------------------
$widget = New-Object System.Windows.Forms.Form
$widget.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$widget.ShowInTaskbar   = $false
$widget.TopMost         = $true
$widget.Opacity         = $WidgetOpacity
$widget.Size            = New-Object System.Drawing.Size 208, 78
$widget.BackColor       = [System.Drawing.Color]::FromArgb(22, 24, 28)
$widget.StartPosition   = [System.Windows.Forms.FormStartPosition]::Manual

# cantos arredondados
$gp = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 14; $w = $widget.Width; $h = $widget.Height
$gp.AddArc(0, 0, $r, $r, 180, 90)
$gp.AddArc(($w-$r), 0, $r, $r, 270, 90)
$gp.AddArc(($w-$r), ($h-$r), $r, $r, 0, 90)
$gp.AddArc(0, ($h-$r), $r, $r, 90, 90)
$gp.CloseFigure()
$widget.Region = New-Object System.Drawing.Region $gp

# posicao salva, ou canto inferior direito
$wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$script:WidgetPos = New-Object System.Drawing.Point `
    (($wa.Right - $widget.Width - 16)), (($wa.Bottom - $widget.Height - 16))
if (Test-Path $PosFile) {
    try {
        $p = (Get-Content $PosFile -Raw).Trim().Split(',')
        $script:WidgetPos = New-Object System.Drawing.Point ([int]$p[0]), ([int]$p[1])
    } catch { }
}

# Mantem a janela inteira dentro da area util da tela mais proxima.
# (o form so respeita Location depois que o handle existe, dai reaplicarmos
#  isso apos o Show() em Set-WidgetVisible)
function Set-WidgetPosition([System.Drawing.Point]$p) {
    $sc = [System.Windows.Forms.Screen]::FromPoint($p)
    if (-not $sc) { $sc = [System.Windows.Forms.Screen]::PrimaryScreen }
    $a = $sc.WorkingArea
    $x = [Math]::Min([Math]::Max($p.X, $a.Left), ($a.Right  - $widget.Width))
    $y = [Math]::Min([Math]::Max($p.Y, $a.Top),  ($a.Bottom - $widget.Height))
    $script:WidgetPos = New-Object System.Drawing.Point ([int]$x), ([int]$y)
    $widget.Location  = $script:WidgetPos
}

$script:CurState = $null

$widget.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $s = $script:CurState
    if (-not $s) { return }

    $accent = Get-AccentColor $s.Pct $s.State
    $dim    = [System.Drawing.Color]::FromArgb(255, 150, 156, 168)

    # faixa de progresso no topo
    $bt = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(60,255,255,255))
    $g.FillRectangle($bt, 0, 0, $sender.Width, 3); $bt.Dispose()
    $ba = New-Object System.Drawing.SolidBrush $accent
    $g.FillRectangle($ba, 0, 0, [float]($sender.Width * [Math]::Min(100,$s.Pct) / 100), 3); $ba.Dispose()

    # valor principal
    if ($NetMonthly -le 0) {
        $main = 'configure o valor'
        $fMain = New-Object System.Drawing.Font 'Segoe UI', 12, ([System.Drawing.FontStyle]::Bold)
        $brM = New-Object System.Drawing.SolidBrush $dim
    } else {
        $main = Format-Money $s.Earned
        $fMain = New-Object System.Drawing.Font 'Segoe UI', 21, ([System.Drawing.FontStyle]::Bold)
        $brM = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,238,240,245))
    }
    $g.DrawString($main, $fMain, $brM, 12, 12)
    $fMain.Dispose(); $brM.Dispose()

    # linha de baixo
    switch ($s.State) {
        'off'    { $sub = $s.Why }
        'before' { $sub = "comeca as $WorkStart" }
        'after'  { $sub = 'jornada concluida' }
        default  { $sub = '{0}%  ·  faltam {1}' -f [int][Math]::Floor($s.Pct), (Format-Span $s.Remaining) }
    }
    if ($NetMonthly -gt 0 -and $s.State -ne 'off') {
        $sub = $sub + '  ·  de ' + (Format-Money $s.DayValue)
    }
    $fSub = New-Object System.Drawing.Font 'Segoe UI', 8
    $brS  = New-Object System.Drawing.SolidBrush $dim
    $g.DrawString($sub, $fSub, $brS, 14, 54)
    $fSub.Dispose(); $brS.Dispose()
})

# arrastar a janela
$script:Drag = $false
$script:DragOff = New-Object System.Drawing.Point 0,0
$widget.Add_MouseDown({
    param($sender,$e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $script:Drag = $true
        $script:DragOff = New-Object System.Drawing.Point $e.X, $e.Y
    }
})
$widget.Add_MouseMove({
    param($sender,$e)
    if ($script:Drag) {
        $sender.Location = New-Object System.Drawing.Point `
            (($sender.Location.X + $e.X - $script:DragOff.X)), `
            (($sender.Location.Y + $e.Y - $script:DragOff.Y))
    }
})
$widget.Add_MouseUp({
    param($sender,$e)
    if ($script:Drag) {
        $script:Drag = $false
        Set-WidgetPosition $sender.Location
        try { "$($script:WidgetPos.X),$($script:WidgetPos.Y)" | Set-Content -Path $PosFile -Encoding UTF8 } catch { }
    }
})

function Set-WidgetVisible([bool]$show) {
    if ($show) {
        $widget.Show()
        Set-WidgetPosition $script:WidgetPos   # so cola depois que o handle existe
        $widget.TopMost = $true
    } else {
        $widget.Hide()
    }
}

# ---------------------------------------------------------------------
#  Bandeja
# ---------------------------------------------------------------------
# icone 1: porcentagem da jornada
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Visible = $ShowPctIcon

# icone 2: reais acumulados no dia
$notifyMoney = New-Object System.Windows.Forms.NotifyIcon
$notifyMoney.Visible = ($ShowMoneyIcon -and $NetMonthly -gt 0)

$menu     = New-Object System.Windows.Forms.ContextMenuStrip
$miStatus = $menu.Items.Add('...')
$miStatus.Enabled = $false
$miMoney  = $menu.Items.Add('...')
$miMoney.Enabled = $false
[void]$menu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))

$miWidget = New-Object System.Windows.Forms.ToolStripMenuItem 'Mostrar widget de R$'
$miWidget.CheckOnClick = $true
$miWidget.Checked      = $WidgetVisible
$miWidget.Add_Click({ Set-WidgetVisible $miWidget.Checked })
[void]$menu.Items.Add($miWidget)

$miAuto = New-Object System.Windows.Forms.ToolStripMenuItem 'Iniciar com o Windows'
$miAuto.CheckOnClick = $true
$miAuto.Checked      = Test-Autostart
$miAuto.Add_Click({ Set-Autostart $miAuto.Checked })
[void]$menu.Items.Add($miAuto)

$miEdit = New-Object System.Windows.Forms.ToolStripMenuItem 'Editar configuracao...'
$miEdit.Add_Click({ Start-Process notepad.exe -ArgumentList $ScriptPath })
[void]$menu.Items.Add($miEdit)

[void]$menu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))
$miExit = New-Object System.Windows.Forms.ToolStripMenuItem 'Sair'
$miExit.Add_Click({
    $notify.Visible = $false;      $notify.Dispose()
    $notifyMoney.Visible = $false; $notifyMoney.Dispose()
    [System.Windows.Forms.Application]::Exit()
})
[void]$menu.Items.Add($miExit)
$notify.ContextMenuStrip      = $menu
$notifyMoney.ContextMenuStrip = $menu

# a widget nunca pode ficar presa: botao direito nela abre o mesmo menu
# e Esc (com ela em foco) oculta na hora
$widget.ContextMenuStrip = $menu
$widget.KeyPreview = $true
$widget.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
        $miWidget.Checked = $false
        Set-WidgetVisible $false
    }
})

# duplo clique em qualquer um dos icones = mostra/oculta o widget
$toggleWidget = {
    $miWidget.Checked = -not $miWidget.Checked
    Set-WidgetVisible $miWidget.Checked
}
$notify.Add_MouseDoubleClick($toggleWidget)
$notifyMoney.Add_MouseDoubleClick($toggleWidget)

$script:LastIconPct    = $null
$script:LastIconMoney  = $null
$script:LastLabelPct   = $null
$script:LastLabelMoney = $null
$script:Notified       = $false
$script:LastDay        = (Get-Date).Date

function Update-All {
    $s = Get-WorkdayState
    $script:CurState = $s

    if ((Get-Date).Date -ne $script:LastDay) {
        $script:LastDay  = (Get-Date).Date
        $script:Notified = $false
    }

    $pctInt = [int][Math]::Floor($s.Pct)

    # --- icone 1: porcentagem da jornada ---
    if ($notify.Visible) {
        $lblPct = if ($s.State -eq 'off') { '-' } else { [string]$pctInt }
        if ($lblPct -ne $script:LastLabelPct) {
            $script:LastLabelPct = $lblPct
            $ic = New-TrayIcon $s.Pct $s.State $lblPct
            $notify.Icon = $ic
            if ($script:LastIconPct) { $script:LastIconPct.Dispose() }
            $script:LastIconPct = $ic
        }
        switch ($s.State) {
            'off'    { $tipPct = "Fora da jornada ($($s.Why))" }
            'before' { $tipPct = 'Jornada comeca as {0}' -f $WorkStart }
            'after'  { $tipPct = 'Jornada concluida - 100%' }
            default  { $tipPct = '{0}% - {1} feitas, faltam {2}' -f $pctInt, (Format-Span $s.Elapsed), (Format-Span $s.Remaining) }
        }
        if ($tipPct.Length -gt 62) { $tipPct = $tipPct.Substring(0,62) }
        $notify.Text   = $tipPct
        $miStatus.Text = $tipPct
    }

    # --- icone 2: reais acumulados ---
    if ($notifyMoney.Visible) {
        $lblMoney = if ($s.State -eq 'off') { '-' } else { [string][int][Math]::Floor($s.Earned) }
        # so redesenha quando o inteiro muda (a cada ~R$ 1)
        if ($lblMoney -ne $script:LastLabelMoney) {
            $script:LastLabelMoney = $lblMoney
            $ic = New-TrayIcon $s.Pct $s.State $lblMoney
            $notifyMoney.Icon = $ic
            if ($script:LastIconMoney) { $script:LastIconMoney.Dispose() }
            $script:LastIconMoney = $ic
        }
        switch ($s.State) {
            'off'    { $tipM = "Fora da jornada ($($s.Why))" }
            'before' { $tipM = '{0} previstos hoje' -f (Format-Money $s.DayValue) }
            'after'  { $tipM = '{0} - dia completo' -f (Format-Money $s.DayValue) }
            default  { $tipM = '{0} de {1} ({2}%)' -f (Format-Money $s.Earned), (Format-Money $s.DayValue), $pctInt }
        }
        if ($tipM.Length -gt 62) { $tipM = $tipM.Substring(0,62) }
        $notifyMoney.Text = $tipM
    }
    if ($NetMonthly -gt 0) {
        $miMoney.Text = '{0} de {1} hoje  ({2} dias uteis no mes)' -f `
            (Format-Money $s.Earned), (Format-Money $s.DayValue), (Get-BusinessDaysInMonth (Get-Date))
    } else {
        $miMoney.Text = 'R$: defina $NetMonthly no script'
    }

    if ($widget.Visible) { $widget.Invalidate() }

    if ($NotifyEnd -and $s.State -eq 'after' -and -not $script:Notified) {
        $script:Notified = $true
        $notify.BalloonTipTitle = 'Jornada concluida'
        $txt = 'Voce bateu os 100% de hoje.'
        if ($NetMonthly -gt 0) { $txt = "$txt Total: $(Format-Money $s.DayValue)." }
        $notify.BalloonTipText = $txt
        $notify.ShowBalloonTip(5000)
    }
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = [Math]::Max(1, $RefreshSec) * 1000
$timer.Add_Tick({ Update-All })
$timer.Start()

Update-All
if ($WidgetVisible) { Set-WidgetVisible $true }

$ctx = New-Object System.Windows.Forms.ApplicationContext
[System.Windows.Forms.Application]::Run($ctx)
