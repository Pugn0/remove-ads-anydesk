# Remover Anúncio/Propaganda Do AnyDesk 🧹

Script PowerShell para localizar e remover automaticamente os arquivos de configuração que geram propagandas no AnyDesk.

## 🚀 Instalação (One-Liner)

Abra o **PowerShell como Administrador** e execute:

```powershell
irm https://raw.githubusercontent.com/Pugn0/remove-ads-anydesk/main/remover_ads_anydesk.ps1 | iex
```

Isso vai:
1. Remover os arquivos de ads do AnyDesk
2. Instalar o comando global `anydesk`

## ⚡ Uso após instalação

Depois de instalar, basta abrir **qualquer terminal** (CMD ou PowerShell) e digitar:

```
anydesk
```

O script será baixado e executado automaticamente, sempre com a versão mais recente.

## 💻 Execução Local

1. Baixe o repositório
2. Execute `iniciar.bat` como **Administrador**, ou:

```powershell
PowerShell -ExecutionPolicy Bypass -File remover_ads_anydesk.ps1
```

No modo local, um menu interativo será exibido com opções de visualizar, apagar arquivos e instalar o comando global.

## 🔧 O que o script faz

- Localiza a pasta `AnyDesk` em `%APPDATA%`
- Remove **todos os arquivos** exceto:
  - `user.conf` (configurações do usuário)
  - Pasta `thumbnails/`
- Instala o comando `anydesk` globalmente no sistema
- Exibe resumo do que foi removido

## ⚠️ Aviso

- Este script **não desinstala o AnyDesk**, apenas remove arquivos de configuração que geram propagandas.
- Requer execução como **Administrador** para instalar o comando global.

## 📋 Modos de execução

| Modo | Comando | Comportamento |
|------|---------|---------------|
| Remoto | `irm URL \| iex` | Remove ads + instala comando global |
| Local | `.bat` ou `-File` | Menu interativo com confirmação |
| Global | `anydesk` | Executa remotamente (após instalação) |

---

### 👤 Créditos

Desenvolvido por [Pugno](https://t.me/pugno_fc)
