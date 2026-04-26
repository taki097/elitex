Clear-Host
$Host.UI.RawUI.WindowTitle = "EliteX Optimizer PRO MAX"

# ===== AUTO BOOST BACKGROUND =====
$global:boosting = $false

function Start-AutoBoost {
    $global:boosting = $true
    Write-Host "Auto Boost Running..." -ForegroundColor Cyan

    while ($global:boosting) {

        # Kill useless apps
        Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
        Stop-Process -Name msedge -Force -ErrorAction SilentlyContinue

        # Minecraft
        $mc = Get-Process javaw -ErrorAction SilentlyContinue
        if ($mc) { $mc.PriorityClass = "High" }

        # Valorant
        $valo = Get-Process VALORANT-Win64-Shipping -ErrorAction SilentlyContinue
        if ($valo) { $valo.PriorityClass = "High" }

        Start-Sleep -Seconds 5
    }
}

function Stop-AutoBoost {
    $global:boosting = $false
    Write-Host "Auto Boost Stopped!" -ForegroundColor Yellow
}

# ===== MENU =====
function Show-Menu {
    Clear-Host
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "      ELITEX OPTIMIZER PRO MAX" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "[1] FPS BOOST"
    Write-Host "[2] RAM CLEAN"
    Write-Host "[3] TEMP CLEAN"
    Write-Host "[4] GAME BOOST"
    Write-Host "[5] PERFORMANCE MODE"
    Write-Host "[6] AUTO BOOST (START)"
    Write-Host "[7] AUTO BOOST (STOP)"
    Write-Host "[8] SYSTEM STATS"
    Write-Host "[9] EXIT"
    Write-Host ""
}

# ===== FUNCTIONS =====
function FPS-Boost {
    Write-Host "Applying FPS Tweaks..." -ForegroundColor Yellow
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
    Write-Host "Done!" -ForegroundColor Green
    Pause
}

function RAM-Clean {
    Write-Host "Cleaning RAM..." -ForegroundColor Yellow
    Get-Process | Where-Object {$_.Responding -eq $false} | Stop-Process -Force -ErrorAction SilentlyContinue
    [System.GC]::Collect()
    Write-Host "Done!" -ForegroundColor Green
    Pause
}

function Temp-Clean {
    Write-Host "Cleaning Temp..." -ForegroundColor Yellow
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Done!" -ForegroundColor Green
    Pause
}

function Game-Boost {
    Write-Host "Boosting Game..." -ForegroundColor Yellow

    $mc = Get-Process javaw -ErrorAction SilentlyContinue
    if ($mc) { $mc.PriorityClass = "High"; Write-Host "Minecraft Boosted!" }

    $valo = Get-Process VALORANT-Win64-Shipping -ErrorAction SilentlyContinue
    if ($valo) { $valo.PriorityClass = "High"; Write-Host "Valorant Boosted!" }

    Pause
}

function Perf-Mode {
    powercfg -setactive SCHEME_MIN | Out-Null
    Write-Host "Performance Mode ON!" -ForegroundColor Green
    Pause
}

function System-Stats {
    Clear-Host
    Write-Host "=== SYSTEM STATS ===" -ForegroundColor Cyan
    Get-CimInstance Win32_Processor | Select-Object Name,LoadPercentage
    Get-CimInstance Win32_OperatingSystem | Select-Object FreePhysicalMemory
    Pause
}

# ===== LOOP =====
while ($true) {
    Show-Menu
    $c = Read-Host "Select"

    switch ($c) {
        "1" { FPS-Boost }
        "2" { RAM-Clean }
        "3" { Temp-Clean }
        "4" { Game-Boost }
        "5" { Perf-Mode }
        "6" { Start-Job -ScriptBlock ${function:Start-AutoBoost} }
        "7" { Stop-AutoBoost }
        "8" { System-Stats }
        "9" { break }
        default { Write-Host "Invalid!" -ForegroundColor Red; Pause }
    }
}