# Script para gerenciar arquivos do AnyDesk
# Execucao local: PowerShell -ExecutionPolicy Bypass -File remover_ads_anydesk.ps1
# Execucao remota: irm https://raw.githubusercontent.com/SEU_USUARIO/remove-ads-anydesk/main/remover_ads_anydesk.ps1 | iex

# Detecta se esta sendo executado via pipe (irm | iex)
function Test-RemoteExecution {
    try {
        # Quando executado via iex, $MyInvocation.MyCommand.Path eh nulo
        return [string]::IsNullOrEmpty($MyInvocation.ScriptName) -and [string]::IsNullOrEmpty($PSCommandPath)
    } catch {
        return $true
    }
}

function Get-AnydeskPath {
    return Join-Path $env:APPDATA "AnyDesk"
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
        Write-Host "Nenhum arquivo para apagar." -ForegroundColor Yellow
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
        Write-Host "[Modo remoto] Executando automaticamente..." -ForegroundColor Magenta
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
    Write-Host "3. Sair"
    Write-Host ""
}

# === EXECUCAO PRINCIPAL ===

$isRemote = Test-RemoteExecution

if ($isRemote) {
    # Modo remoto: executa direto sem menu
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "  EXECUCAO REMOTA DETECTADA" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta
    Remove-AnydeskFiles -AutoConfirm
} else {
    # Modo local: menu interativo
    do {
        Show-Menu
        $opcao = Read-Host "Escolha uma opcao (1-3)"

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
