# Script para gerenciar arquivos do AnyDesk
# Salve como: remover_ads_anydesk.ps1
# Execute com: PowerShell -ExecutionPolicy Bypass -File remover_ads_anydesk.ps1

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

function Get-AnydeskPath {
    return Join-Path $env:APPDATA "AnyDesk"
}

function Remove-AnydeskFiles {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  APAGAR ARQUIVOS" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    $anydeskPath = Get-AnydeskPath
    
    if (Test-Path $anydeskPath) {
        Write-Host "Encontrado: $anydeskPath" -ForegroundColor Green
        Write-Host ""
        Write-Host "ATENCAO: Os seguintes arquivos serao apagados:" -ForegroundColor Yellow
        Write-Host ""
        
        # Lista arquivos que serão apagados
        $filesToDelete = Get-ChildItem -Path $anydeskPath -File | Where-Object { $_.Name -ne "user.conf" }
        
        if ($filesToDelete.Count -eq 0) {
            Write-Host "Nenhum arquivo para apagar." -ForegroundColor Yellow
        } else {
            foreach ($file in $filesToDelete) {
                Write-Host "- $($file.Name)"
            }
            
            Write-Host ""
            $confirmacao = Read-Host "Deseja continuar? (S/N)"
            
            if ($confirmacao -eq "S" -or $confirmacao -eq "s") {
                Write-Host ""
                Write-Host "Apagando arquivos..." -ForegroundColor Yellow
                Write-Host ""
                
                foreach ($file in $filesToDelete) {
                    try {
                        Remove-Item -Path $file.FullName -Force
                        Write-Host "Apagado: $($file.Name)" -ForegroundColor Green
                    } catch {
                        Write-Host "Erro ao apagar: $($file.Name)" -ForegroundColor Red
                    }
                }
                
                Write-Host ""
                Write-Host "Arquivos protegidos:" -ForegroundColor Cyan
                if (Test-Path (Join-Path $anydeskPath "user.conf")) {
                    Write-Host "- user.conf (arquivo)" -ForegroundColor Green
                }
                
                Write-Host ""
                Write-Host "Pastas protegidas:" -ForegroundColor Cyan
                if (Test-Path (Join-Path $anydeskPath "thumbnails")) {
                    Write-Host "- thumbnails (pasta)" -ForegroundColor Green
                }
                
                Write-Host ""
                Write-Host "Concluido!" -ForegroundColor Green
            } else {
                Write-Host ""
                Write-Host "Operacao cancelada." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "Pasta AnyDesk nao encontrada em $env:APPDATA" -ForegroundColor Red
    }
    
    Write-Host ""
    Read-Host "Pressione ENTER para continuar"
}

function Show-AnydeskFiles {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  ARQUIVOS NO DIRETORIO ANYDESK" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    $anydeskPath = Get-AnydeskPath
    
    if (Test-Path $anydeskPath) {
        Write-Host "Diretorio: $anydeskPath" -ForegroundColor Green
        Write-Host ""
        Write-Host "Arquivos encontrados:" -ForegroundColor Cyan
        Write-Host ""
        
        $items = Get-ChildItem -Path $anydeskPath
        
        foreach ($item in $items) {
            if ($item.PSIsContainer) {
                Write-Host "[PASTA] $($item.Name)" -ForegroundColor Yellow
            } else {
                Write-Host "[ARQUIVO] $($item.Name)"
            }
        }
        
        Write-Host ""
        Write-Host "Total: $($items.Count) itens" -ForegroundColor Cyan
    } else {
        Write-Host "Pasta AnyDesk nao encontrada em $env:APPDATA" -ForegroundColor Red
    }
    
    Write-Host ""
    Read-Host "Pressione ENTER para continuar"
}

# Loop principal do menu
do {
    Show-Menu
    $opcao = Read-Host "Escolha uma opcao (1-3)"
    
    switch ($opcao) {
        "1" { Remove-AnydeskFiles }
        "2" { Show-AnydeskFiles }
        "3" { 
            Clear-Host
            Write-Host ""
            Write-Host "Encerrando..." -ForegroundColor Cyan
            Write-Host ""
            Start-Sleep -Seconds 1
            exit
        }
        default {
            Write-Host ""
            Write-Host "Opcao invalida! Pressione ENTER para tentar novamente..." -ForegroundColor Red
            Read-Host
        }
    }
} while ($true)