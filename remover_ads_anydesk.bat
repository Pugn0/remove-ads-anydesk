@echo off
setlocal

rem Obtém a pasta AppData\Roaming do usuário atual
set "ROAMING_PATH=%APPDATA%"

rem Define o caminho para a pasta AnyDesk
set "ANYDESK_PATH=%ROAMING_PATH%\AnyDesk"

rem Verifica se a pasta existe
if exist "%ANYDESK_PATH%" (
    echo Encontrado: %ANYDESK_PATH%
    
    rem Apaga os arquivos se existirem
    if exist "%ANYDESK_PATH%\service.conf" (
        del /f /q "%ANYDESK_PATH%\service.conf"
        echo Arquivo service.conf apagado.
    ) else (
        echo Arquivo service.conf não encontrado.
    )

    if exist "%ANYDESK_PATH%\system.conf" (
        del /f /q "%ANYDESK_PATH%\system.conf"
        echo Arquivo system.conf apagado.
    ) else (
        echo Arquivo system.conf não encontrado.
    )
) else (
    echo Pasta AnyDesk não encontrada em %ROAMING_PATH%
)

endlocal
pause
