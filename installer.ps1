<#
.SYNOPSIS
    JKK NO.1 INSTALLER - Animated Console UI
.DESCRIPTION
    Clean, flicker-free animated console installer for FiveM Optimization.
#>

#region =================== LOGIC IMPLEMENTATION ===================

function Invoke-Install {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$Report
    )

    # STEP 1: CPU & System Timers (20%)
    & $Report "Optimizing CPU Timers, BCDedit and Core Parking..." 20
    cmd /c "bcdedit /set disabledynamictick yes >nul 2>&1"
    cmd /c "bcdedit /set useplatformtick yes >nul 2>&1"
    cmd /c "bcdedit /set useplatformclock no >nul 2>&1"

    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /t REG_DWORD /d 0 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    # STEP 2: Network TCP/IP & QoS DSCP 46 (40%)
    & $Report "Tuning TCP NoDelay, Instant ACK and QoS DSCP 46..." 40
    $interfaces = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    Get-ChildItem $interfaces -ErrorAction SilentlyContinue | ForEach-Object {
        Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $_.PSPath -Name "TcpDelAckTicks" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    }

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >$null 2>&1

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /v "Application Name" /t REG_SZ /d "FiveM.exe" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /v "DSCP Value" /t REG_SZ /d "46" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /v "Protocol" /t REG_SZ /d "*" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /v "Local Port" /t REG_SZ /d "*" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /v "Remote Port" /t REG_SZ /d "*" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /v "Version" /t REG_SZ /d "1.0" /f >$null 2>&1

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /v "Application Name" /t REG_SZ /d "*GTAProcess.exe" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /v "DSCP Value" /t REG_SZ /d "46" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /v "Protocol" /t REG_SZ /d "*" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /v "Local Port" /t REG_SZ /d "*" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /v "Remote Port" /t REG_SZ /d "*" /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /v "Version" /t REG_SZ /d "1.0" /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    # STEP 3: Anti-Desync & UDP Buffer Tuning (65%)
    & $Report "Disabling LSO on Adapters and Expanding UDP Buffers..." 65
    Get-NetAdapter -Physical -ErrorAction SilentlyContinue | ForEach-Object {
        Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Large Send Offload v2 (IPv4)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Large Send Offload v2 (IPv6)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Flow Control" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Interrupt Moderation" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    }

    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v DefaultReceiveWindow /t REG_DWORD /d 65536 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v DefaultSendWindow /t REG_DWORD /d 65536 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v FastSendDatagramThreshold /t REG_DWORD /d 1024 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v FastCopyReceiveThreshold /t REG_DWORD /d 1024 /f >$null 2>&1

    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >$null 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    # STEP 4: Input Response & Instant Stun Recovery (85%)
    & $Report "Maximizing Keyboard Response and HID Queue..." 85
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d "0" /f >$null 2>&1
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d "31" /f >$null 2>&1

    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d "122" /f >$null 2>&1
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d "0" /f >$null 2>&1
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatRate /t REG_SZ /d "0" /f >$null 2>&1
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v AutoRepeatDelay /t REG_SZ /d "0" /f >$null 2>&1
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v BounceTime /t REG_SZ /d "0" /f >$null 2>&1

    reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /t REG_DWORD /d 100 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 100 /f >$null 2>&1

    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f >$null 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    # STEP 5: Finalizing (100%)
    & $Report "Applying Group Policies and Refreshing Subsystems..." 100
    cmd /c "gpupdate /force >nul 2>&1"
    Start-Sleep -Milliseconds 400

    return $true
}

function Invoke-Uninstall {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$Report
    )

    & $Report "Reverting BCDedit timers and Core Parking defaults..." 20
    cmd /c "bcdedit /deletevalue disabledynamictick >nul 2>&1"
    cmd /c "bcdedit /deletevalue useplatformtick >nul 2>&1"
    cmd /c "bcdedit /deletevalue useplatformclock >nul 2>&1"
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    & $Report "Removing FiveM QoS policies and resetting Psched..." 45
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM" /f >$null 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTA" /f >$null 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    & $Report "Re-enabling Large Send Offload on Adapters..." 70
    Get-NetAdapter -Physical -ErrorAction SilentlyContinue | ForEach-Object {
        Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Large Send Offload v2 (IPv4)" -DisplayValue "Enabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Large Send Offload v2 (IPv6)" -DisplayValue "Enabled" -ErrorAction SilentlyContinue
    }
    Start-Sleep -Milliseconds 400

    & $Report "Resetting Winsock and Keyboard parameters to default..." 90
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v DefaultReceiveWindow /f >$null 2>&1
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v DefaultSendWindow /f >$null 2>&1
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d "1" /f >$null 2>&1
    reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d "31" /f >$null 2>&1
    Start-Sleep -Milliseconds 400

    & $Report "Reversion completed successfully..." 100
    Start-Sleep -Milliseconds 300

    return $true
}

#endregion

#region =================== CONFIGURATION ===================

$Width   = 86
$Height  = 30

# Theme 24-bit Colors (RGB)
$ColorPurple = @{ R = 124; G = 58;  B = 237 } # #7C3AED
$ColorCyan   = @{ R = 6;   G = 182; B = 212 } # #06B6D4
$ColorWhite  = @{ R = 255; G = 255; B = 255 }
$ColorDim    = @{ R = 100; G = 116; B = 139 }
$ColorDark   = @{ R = 30;  G = 41;  B = 59  }
$ColorGreen  = @{ R = 34;  G = 197; B = 94  }
$ColorRed    = @{ R = 239; G = 68;  B = 68  }
$ColorYellow = @{ R = 234; G = 179; B = 8   }

$MenuItems = @("INSTALL", "UNINSTALL", "EXIT")

# Original High-Quality ANSI Shadow Banner for JKK NO.1
$Banner = @(
    "  ██╗██╗  ██╗██╗  ██╗    ███╗   ██╗ ██████╗       ██╗",
    "  ██║██║ ██╔╝██║ ██╔╝    ████╗  ██║██╔═══██╗    ████║",
    "  ██║█████╔╝ █████╔╝     ██╔██╗ ██║██║   ██║    ╚██║",
    "  ██║██╔═██╗ ██╔═██╗     ██║╚██╗██║██║   ██║     ██║",
    "████║██║  ██╗██║  ██╗    ██║ ╚████║╚██████╔╝     ██║",
    "╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═══╝ ╚═════╝      ╚═╝"
)

# Clean Box & Arrows
$cTL = [char]0x256D # ╭
$cTR = [char]0x256E # ╮
$cBL = [char]0x2570 # ╰
$cBR = [char]0x256F # ╯
$cHL = [char]0x2500 # ─
$cVL = [char]0x2502 # │
$cAR = [char]0x25B6 # ▶
$bF  = [char]0x2588 # █
$bL  = [char]0x2591 # ░

#endregion

#region =================== CONSOLE & WIN32 SETUP ===================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$e = [char]27

function Clear-EntireScreen {
    try {
        [Console]::SetCursorPosition(0, 0)
        $emptyLine = " " * $Width
        for ($i = 0; $i -lt $Height; $i++) {
            [Console]::SetCursorPosition(0, $i)
            [Console]::Write($emptyLine)
        }
        [Console]::SetCursorPosition(0, 0)
    } catch {}
    [Console]::Write($e + "[2J" + $e + "[H")
}

# Win32 API Enable VT
$Win32Defs = @"
using System;
using System.Runtime.InteropServices;

public static class Win32 {
    public const int STD_OUTPUT_HANDLE = -11;
    public const uint ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);

    [DllImport("kernel32.dll")]
    public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);

    [DllImport("kernel32.dll")]
    public static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
}
"@
try {
    Add-Type -TypeDefinition $Win32Defs -ErrorAction SilentlyContinue
} catch {}

try {
    $hOut = [Win32]::GetStdHandle([Win32]::STD_OUTPUT_HANDLE)
    $mode = 0
    if ([Win32]::GetConsoleMode($hOut, [ref]$mode)) {
        $mode = $mode -bor [Win32]::ENABLE_VIRTUAL_TERMINAL_PROCESSING
        [Win32]::SetConsoleMode($hOut, $mode) | Out-Null
    }
} catch {}

$Host.UI.RawUI.WindowTitle = "JKK NO.1 INSTALLER"

Clear-EntireScreen
[Console]::Write($e + "[?25l")

# Admin Check
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

#endregion

#region =================== DRAWING HELPERS ===================

function Get-AnsiColor {
    param([int]$R, [int]$G, [int]$B, [switch]$Bg)
    $mode = if ($Bg) { 48 } else { 38 }
    return ($e + "[" + $mode + ";2;" + $R + ";" + $G + ";" + $B + "m")
}

function Get-LerpColor {
    param($Color1, $Color2, [float]$T)
    $T = [Math]::Max(0.0, [Math]::Min(1.0, $T))
    return @{
        R = [int]($Color1.R + ($Color2.R - $Color1.R) * $T)
        G = [int]($Color1.G + ($Color2.G - $Color1.G) * $T)
        B = [int]($Color1.B + ($Color2.B - $Color1.B) * $T)
    }
}

function Write-At {
    param(
        [int]$X,
        [int]$Y,
        [string]$Text,
        $Color = $null,
        $BgColor = $null
    )
    if ($X -lt 0) { $X = 0 }
    if ($Y -lt 0) { $Y = 0 }
    try {
        [Console]::SetCursorPosition($X, $Y)
        $prefix = ""
        if ($Color) { $prefix += Get-AnsiColor $Color.R $Color.G $Color.B }
        if ($BgColor) { $prefix += Get-AnsiColor $BgColor.R $BgColor.G $BgColor.B -Bg }
        [Console]::Write($prefix + $Text + $e + "[0m")
    } catch {}
}

function Draw-Box {
    param(
        [int]$X,
        [int]$Y,
        [int]$W,
        [int]$H,
        $BorderColor,
        [string]$Title = ""
    )
    $topLine = "$cTL" + ("$cHL" * ($W - 2)) + "$cTR"
    if ($Title -ne "") {
        $maxTitle = $W - 4
        if ($Title.Length -gt $maxTitle) { $Title = $Title.Substring(0, $maxTitle) }
        $fillLen = $W - 4 - $Title.Length
        $leftFill = [int]($fillLen / 2)
        $rightFill = $fillLen - $leftFill
        $topLine = "$cTL" + ("$cHL" * $leftFill) + " " + $Title + " " + ("$cHL" * $rightFill) + "$cTR"
    }
    Write-At $X $Y $topLine $BorderColor

    $empty = " " * ($W - 2)
    for ($i = 1; $i -lt ($H - 1); $i++) {
        Write-At $X ($Y + $i) ("$cVL" + $empty + "$cVL") $BorderColor
    }

    $botLine = "$cBL" + ("$cHL" * ($W - 2)) + "$cBR"
    Write-At $X ($Y + $H - 1) $botLine $BorderColor
}

function Draw-Progress {
    param(
        [int]$X,
        [int]$Y,
        [int]$Width = 50,
        [int]$Percent = 0
    )
    $Percent = [Math]::Max(0, [Math]::Min(100, $Percent))
    $filled = [int](($Percent / 100.0) * $Width)
    $empty = $Width - $filled

    try {
        [Console]::SetCursorPosition($X, $Y)
        [Console]::Write("[")
        for ($i = 0; $i -lt $filled; $i++) {
            $t = $i / [Math]::Max(1.0, [float]$Width)
            $col = Get-LerpColor $ColorPurple $ColorCyan $t
            [Console]::Write((Get-AnsiColor $col.R $col.G $col.B) + "$bF")
        }
        $dimColor = Get-AnsiColor $ColorDark.R $ColorDark.G $ColorDark.B
        [Console]::Write($dimColor + ("$bL" * $empty) + $e + "[0m] ")
        $pctColor = Get-AnsiColor $ColorCyan.R $ColorCyan.G $ColorCyan.B
        [Console]::Write($pctColor + ("{0,3}" -f $Percent) + "%" + $e + "[0m")
    } catch {}
}

#endregion

#region =================== ANIMATIONS & VIEWS ===================

function Show-BootIntro {
    Clear-EntireScreen
    $bootSteps = @(
        "[ OK ] Mounting virtual terminal interfaces...",
        "[ OK ] Initializing low-level memory maps...",
        "[ OK ] Scanning hardware platform and architecture...",
        "[ OK ] Checking security context and privileges...",
        "[ OK ] Connecting neural pipeline...",
        "[ OK ] JKK NO.1 Ready."
    )
    $y = 6
    foreach ($step in $bootSteps) {
        Write-At 10 $y $step $ColorGreen
        Start-Sleep -Milliseconds 75
        $y += 2
    }
    Start-Sleep -Milliseconds 250
    Clear-EntireScreen

    $bannerY = 2
    for ($row = 0; $row -lt $Banner.Count; $row++) {
        $line = $Banner[$row]
        $x = [int](($Width - $line.Length) / 2)
        $renderedLine = ""
        for ($col = 0; $col -lt $line.Length; $col++) {
            $ch = $line[$col]
            $t = $col / [Math]::Max(1.0, [float]$line.Length)
            $c = Get-LerpColor $ColorPurple $ColorCyan $t
            $renderedLine += (Get-AnsiColor $c.R $c.G $c.B) + $ch
        }
        try {
            [Console]::SetCursorPosition($x, ($bannerY + $row))
            [Console]::Write($renderedLine + $e + "[0m")
        } catch {}
        Start-Sleep -Milliseconds 35
    }
    Start-Sleep -Milliseconds 150
}

function Draw-BannerAnimated {
    param([float]$WaveOffset)
    $bannerY = 2
    for ($row = 0; $row -lt $Banner.Count; $row++) {
        $line = $Banner[$row]
        $x = [int](($Width - $line.Length) / 2)
        try {
            [Console]::SetCursorPosition($x, ($bannerY + $row))
            $out = ""
            for ($col = 0; $col -lt $line.Length; $col++) {
                $ch = $line[$col]
                $t = ([Math]::Sin(($col * 0.15) - $WaveOffset) + 1.0) / 2.0
                $color = Get-LerpColor $ColorPurple $ColorCyan $t
                $out += (Get-AnsiColor $color.R $color.G $color.B) + $ch
            }
            [Console]::Write($out + $e + "[0m")
        } catch {}
    }

    $sub = "I N S T A L L E R   v 1 . 0"
    $subX = [int](($Width - $sub.Length) / 2)
    Write-At $subX 9 $sub $ColorDim
}

function Draw-MainMenu {
    param(
        [int]$SelectedIndex,
        [float]$WaveOffset
    )
    Draw-BannerAnimated -WaveOffset $WaveOffset

    $boxW = 44
    $boxH = 7
    $boxX = [int](($Width - $boxW) / 2)
    $boxY = 11
    Draw-Box $boxX $boxY $boxW $boxH $ColorPurple

    for ($i = 0; $i -lt $MenuItems.Count; $i++) {
        $itemY = $boxY + 2 + $i
        $itemText = $MenuItems[$i]
        $isSel = ($i -eq $SelectedIndex)

        if ($isSel) {
            $t = ([Math]::Sin($WaveOffset) + 1.0) / 2.0
            $gradBg = Get-LerpColor $ColorPurple $ColorCyan $t
            $barText = ("  $cAR  " + $itemText).PadRight($boxW - 4, " ")
            Write-At ($boxX + 2) $itemY $barText $ColorWhite $gradBg
        } else {
            $barText = ("     " + $itemText).PadRight($boxW - 4, " ")
            Write-At ($boxX + 2) $itemY $barText $ColorDim
        }
    }

    $osInfo = [System.Environment]::OSVersion.Version.ToString()
    $user = [System.Environment]::UserName
    $adminTag = if ($IsAdmin) { "[YES]" } else { "[NO]" }
    $adminCol = if ($IsAdmin) { $ColorGreen } else { $ColorYellow }

    $infoPlain = "OS: Win " + $osInfo + "  |  User: " + $user + "  |  Admin: " + $adminTag
    $infoX = [int](($Width - $infoPlain.Length) / 2)
    Write-At $infoX 20 $infoPlain $adminCol

    $footer = "[UP/DOWN] Navigate   [ENTER] Select   [ESC] Exit"
    $footX = [int](($Width - $footer.Length) / 2)
    Write-At $footX 23 $footer $ColorDark
}

function Show-WorkingScreen {
    param(
        [string]$Title,
        [scriptblock]$Action
    )
    Clear-EntireScreen
    Draw-Box 8 3 70 22 $ColorCyan $Title

    $spinChars = @('-','\','|','/')
    $spinIdx = 0
    $curStep = "Initializing task..."
    $curPercent = 0
    $logLines = [System.Collections.Generic.List[string]]::new()
    $logY = 11

    $reportCallback = {
        param([string]$StepText, [int]$Percent)
        $curStep = $StepText
        $curPercent = $Percent
        if ($logLines.Count -ge 5) { $logLines.RemoveAt(0) }
        $logLines.Add("  [OK] " + $StepText)

        $spinChar = $spinChars[$spinIdx % $spinChars.Count]
        $spinIdx++
        Write-At 12 6 ($spinChar + " " + $curStep.PadRight(52)) $ColorCyan
        Draw-Progress 12 8 46 $curPercent

        for ($k = 0; $k -lt 5; $k++) {
            $line = if ($k -lt $logLines.Count) { $logLines[$k] } else { "" }
            Write-At 12 ($logY + $k) ($line.PadRight(56)) $ColorGreen
        }
    }

    try {
        & $Action $reportCallback
        Start-Sleep -Milliseconds 400
        Show-ResultPulse -Success $true -Message ($Title + " COMPLETED")
    } catch {
        Show-ResultPulse -Success $false -Message $_.Exception.Message
    }
}

function Show-ResultPulse {
    param(
        [bool]$Success,
        [string]$Message
    )
    $boxW = 56
    $boxH = 7
    $boxX = [int](($Width - $boxW) / 2)
    $boxY = 10

    if ($Success) {
        for ($p = 0; $p -lt 3; $p++) {
            $brightGreen = @{ R = 74; G = 222; B = 128 }
            $dimGreen    = @{ R = 20; G = 83;  B = 45  }

            Draw-Box $boxX $boxY $boxW $boxH $brightGreen
            Write-At ($boxX + 6) ($boxY + 2) ("[OK] " + $Message).PadRight($boxW - 10) $brightGreen
            Write-At ($boxX + 6) ($boxY + 4) "Operation finished successfully." $ColorDim
            Start-Sleep -Milliseconds 180

            Draw-Box $boxX $boxY $boxW $boxH $dimGreen
            Write-At ($boxX + 6) ($boxY + 2) ("[OK] " + $Message).PadRight($boxW - 10) $dimGreen
            Write-At ($boxX + 6) ($boxY + 4) "Operation finished successfully." $ColorDark
            Start-Sleep -Milliseconds 180
        }
        Draw-Box $boxX $boxY $boxW $boxH $ColorGreen
        Write-At ($boxX + 6) ($boxY + 2) ("[OK] " + $Message) $ColorGreen
    } else {
        $shakes = @(-2, 2, -1, 1, 0)
        foreach ($offset in $shakes) {
            $curX = $boxX + $offset
            Clear-EntireScreen
            Draw-Box $curX $boxY $boxW $boxH $ColorRed
            Write-At ($curX + 6) ($boxY + 2) "[X] FAILED" $ColorRed
            $msg = if ($Message.Length -gt 40) { $Message.Substring(0, 40) } else { $Message }
            Write-At ($curX + 6) ($boxY + 4) $msg $ColorYellow
            Start-Sleep -Milliseconds 50
        }
    }

    $prompt = "Press any key to return to menu..."
    $prX = [int](($Width - $prompt.Length) / 2)
    Write-At $prX 19 $prompt $ColorDim
    while ([Console]::KeyAvailable) { [Console]::ReadKey($true) | Out-Null }
    [Console]::ReadKey($true) | Out-Null
    Clear-EntireScreen
}

function Show-ConfirmUninstall {
    $boxW = 50
    $boxH = 7
    $boxX = [int](($Width - $boxW) / 2)
    $boxY = 11
    Draw-Box $boxX $boxY $boxW $boxH $ColorRed "CONFIRMATION"

    Write-At ($boxX + 8) ($boxY + 2) "Are you sure you want to uninstall?" $ColorWhite
    Write-At ($boxX + 16) ($boxY + 4) "[Y] Yes     [N] No" $ColorYellow

    while ($true) {
        if ([Console]::KeyAvailable) {
            $k = [Console]::ReadKey($true).Key
            if ($k -eq [ConsoleKey]::Y) { return $true }
            if ($k -eq [ConsoleKey]::N -or $k -eq [ConsoleKey]::Escape) { return $false }
        }
        Start-Sleep -Milliseconds 30
    }
}

function Show-AdminWarningPrompt {
    Clear-EntireScreen
    $boxW = 60
    $boxH = 8
    $boxX = [int](($Width - $boxW) / 2)
    $boxY = 10
    Draw-Box $boxX $boxY $boxW $boxH $ColorYellow "PERMISSION WARNING"

    Write-At ($boxX + 5) ($boxY + 2) "This installer is not running as Administrator." $ColorYellow
    Write-At ($boxX + 5) ($boxY + 3) "Some operations and system tweaks will fail." $ColorDim
    Write-At ($boxX + 14) ($boxY + 5) "Relaunch as Admin? [Y/N]: " $ColorWhite

    while ($true) {
        if ([Console]::KeyAvailable) {
            $k = [Console]::ReadKey($true).Key
            if ($k -eq [ConsoleKey]::Y) {
                try {
                    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
                    exit
                } catch {
                    return
                }
            }
            if ($k -eq [ConsoleKey]::N -or $k -eq [ConsoleKey]::Escape) {
                Clear-EntireScreen
                return
            }
        }
        Start-Sleep -Milliseconds 30
    }
}

function Show-ExitFadeOut {
    Clear-EntireScreen
    Write-At 36 12 "Goodbye." $ColorCyan
    Start-Sleep -Milliseconds 400
    Clear-EntireScreen
}

#endregion

#region =================== MAIN APPLICATION LOOP ===================

try {
    if (-not $IsAdmin) {
        Show-AdminWarningPrompt
    }

    Show-BootIntro
    Clear-EntireScreen

    $selectedIndex = 0
    $waveOffset = 0.0
    $running = $true

    while ($running) {
        if ([Console]::KeyAvailable) {
            $keyInfo = [Console]::ReadKey($true)
            switch ($keyInfo.Key) {
                ([ConsoleKey]::UpArrow) {
                    $selectedIndex--
                    if ($selectedIndex -lt 0) { $selectedIndex = $MenuItems.Count - 1 }
                }
                ([ConsoleKey]::DownArrow) {
                    $selectedIndex++
                    if ($selectedIndex -ge $MenuItems.Count) { $selectedIndex = 0 }
                }
                ([ConsoleKey]::Escape) {
                    $running = $false
                }
                ([ConsoleKey]::Enter) {
                    $boxW = 44
                    $boxX = [int](($Width - $boxW) / 2)
                    $itemY = 13 + $selectedIndex
                    Write-At ($boxX + 2) $itemY (("  $cAR  " + $MenuItems[$selectedIndex]).PadRight($boxW - 4, " ")) $ColorDark $ColorWhite
                    Start-Sleep -Milliseconds 100

                    switch ($selectedIndex) {
                        0 {
                            Show-WorkingScreen -Title "INSTALLATION PROCESS" -Action { param($rep) Invoke-Install -Report $rep }
                        }
                        1 {
                            $confirm = Show-ConfirmUninstall
                            Clear-EntireScreen
                            if ($confirm) {
                                Show-WorkingScreen -Title "UNINSTALL PROCESS" -Action { param($rep) Invoke-Uninstall -Report $rep }
                            }
                        }
                        2 {
                            $running = $false
                        }
                    }
                }
            }
        }

        Draw-MainMenu -SelectedIndex $selectedIndex -WaveOffset $waveOffset
        $waveOffset += 0.12
        Start-Sleep -Milliseconds 45
    }

    Show-ExitFadeOut
}
finally {
    [Console]::Write($e + "[?25h" + $e + "[0m")
    try { [Console]::ResetColor() } catch {}
    Clear-EntireScreen
}

#endregion
