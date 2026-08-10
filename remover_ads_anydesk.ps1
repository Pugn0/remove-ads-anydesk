# Script para gerenciar arquivos do AnyDesk
# Execucao local: PowerShell -ExecutionPolicy Bypass -File remover_ads_anydesk.ps1
# Execucao remota: irm https://raw.githubusercontent.com/Pugn0/remove-ads-anydesk/main/remover_ads_anydesk.ps1 | iex

# Detecta se esta sendo executado via pipe (irm | iex)
function Test-RemoteExecution {
    try {
        return [string]::IsNullOrEmpty($MyInvocation.ScriptName) -and [string]::IsNullOrEmpty($PSCommandPath)
    } catch {
        return $true
    }
}

function Get-AnydeskPath {
    return Join-Path $env:APPDATA "AnyDesk"
}

function Install-GlobalCommand {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  INSTALANDO COMANDO GLOBAL 'anydesk'" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""

    $cmdContent = @"
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Pugn0/remove-ads-anydesk/main/remover_ads_anydesk.ps1 | iex"
pause
"@

    # Tenta primeiro em C:\Windows (requer Admin), senao usa pasta do usuario no PATH
    $installed = $false
    $installPaths = @(
        "C:\Windows\anydesk.cmd",
        (Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps\anydesk.cmd")
    )

    foreach ($cmdPath in $installPaths) {
        try {
            $dir = Split-Path $cmdPath -Parent
            if (-not (Test-Path $dir)) {
                New-Item -Path $dir -ItemType Directory -Force | Out-Null
            }
            Set-Content -Path $cmdPath -Value $cmdContent -Force -ErrorAction Stop
            Write-Host "  [OK] Comando 'anydesk' instalado em:" -ForegroundColor Green
            Write-Host "       $cmdPath" -ForegroundColor White
            $installed = $true
            break
        } catch {
            continue
        }
    }

    if ($installed) {
        Write-Host ""
        Write-Host "  Agora voce pode digitar em qualquer terminal:" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "    anydesk" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  E o script sera executado automaticamente." -ForegroundColor Cyan
        Write-Host ""
    } else {
        Write-Host "  [ERRO] Nao foi possivel instalar o comando." -ForegroundColor Red
        Write-Host "  Tente executar como Administrador." -ForegroundColor Yellow
        Write-Host ""
    }
}

function Remove-AnydeskFiles {
    param(
        [switch]$AutoConfirm
    )

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  REMOVER ADS DO ANYDESK" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    $anydeskPath = Get-AnydeskPath

    if (-not (Test-Path $anydeskPath)) {
        Write-Host "Pasta AnyDesk nao encontrada em $env:APPDATA" -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Encontrado: $anydeskPath" -ForegroundColor Green
    Write-Host ""

    # Lista arquivos que serao apagados (protege user.conf e pasta thumbnails)
    $filesToDelete = Get-ChildItem -Path $anydeskPath -File | Where-Object { $_.Name -ne "user.conf" }

    if ($filesToDelete.Count -eq 0) {
        Write-Host "Nenhum arquivo para apagar. Tudo limpo!" -ForegroundColor Yellow
        Write-Host ""
        return
    }

    Write-Host "Arquivos que serao apagados:" -ForegroundColor Yellow
    Write-Host ""
    foreach ($file in $filesToDelete) {
        Write-Host "  - $($file.Name)" -ForegroundColor White
    }
    Write-Host ""

    # Se nao for auto-confirm, pede confirmacao
    if (-not $AutoConfirm) {
        $confirmacao = Read-Host "Deseja continuar? (S/N)"
        if ($confirmacao -ne "S" -and $confirmacao -ne "s") {
            Write-Host ""
            Write-Host "Operacao cancelada." -ForegroundColor Yellow
            return
        }
    } else {
        Write-Host "Executando automaticamente..." -ForegroundColor Magenta
    }

    Write-Host ""
    Write-Host "Apagando arquivos..." -ForegroundColor Yellow
    Write-Host ""

    $removidos = 0
    $erros = 0

    foreach ($file in $filesToDelete) {
        try {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            Write-Host "  [OK] $($file.Name)" -ForegroundColor Green
            $removidos++
        } catch {
            Write-Host "  [ERRO] $($file.Name) - $_" -ForegroundColor Red
            $erros++
        }
    }

    Write-Host ""
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Write-Host "  Removidos: $removidos | Erros: $erros" -ForegroundColor Cyan
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Arquivos/pastas protegidos:" -ForegroundColor Green
    Write-Host "  - user.conf" -ForegroundColor Green
    Write-Host "  - thumbnails/" -ForegroundColor Green
    Write-Host ""
    Write-Host "Concluido!" -ForegroundColor Green
    Write-Host ""
}

function Show-AnydeskFiles {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  ARQUIVOS NO DIRETORIO ANYDESK" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    $anydeskPath = Get-AnydeskPath

    if (-not (Test-Path $anydeskPath)) {
        Write-Host "Pasta AnyDesk nao encontrada em $env:APPDATA" -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Diretorio: $anydeskPath" -ForegroundColor Green
    Write-Host ""

    $items = Get-ChildItem -Path $anydeskPath

    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            Write-Host "  [PASTA]   $($item.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "  [ARQUIVO] $($item.Name)" -ForegroundColor White
        }
    }

    Write-Host ""
    Write-Host "Total: $($items.Count) itens" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  GERENCIADOR DE ARQUIVOS ANYDESK" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Apagar arquivos (exceto user.conf e pasta thumbnails)"
    Write-Host "2. Visualizar arquivos no diretorio"
    Write-Host "3. Instalar comando global 'anydesk'"
    Write-Host "4. Sair"
    Write-Host ""
}

# === EXECUCAO PRINCIPAL ===

$isRemote = Test-RemoteExecution

if ($isRemote) {
    # Modo remoto: remove ads + instala comando global
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "  REMOVE ADS ANYDESK - by Pugno" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta

    # Remove os ads
    Remove-AnydeskFiles -AutoConfirm

    # Instala comando global
    Install-GlobalCommand

} else {
    # Modo local: menu interativo
    do {
        Show-Menu
        $opcao = Read-Host "Escolha uma opcao (1-4)"

        switch ($opcao) {
            "1" { 
                Remove-AnydeskFiles
                Read-Host "Pressione ENTER para continuar"
            }
            "2" { 
                Show-AnydeskFiles
                Read-Host "Pressione ENTER para continuar"
            }
            "3" {
                Install-GlobalCommand
                Read-Host "Pressione ENTER para continuar"
            }
            "4" { 
                Write-Host ""
                Write-Host "Encerrando..." -ForegroundColor Cyan
                Write-Host ""
                exit
            }
            default {
                Write-Host ""
                Write-Host "Opcao invalida!" -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    } while ($true)
}
