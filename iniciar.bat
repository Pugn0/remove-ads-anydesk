@echo off
:: Executa o script PowerShell do AnyDesk
:: Coloque este .bat na mesma pasta do arquivo .ps1

PowerShell -ExecutionPolicy Bypass -File "%~dp0remover_ads_anydesk.ps1"

pause