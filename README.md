# Remover Anúncio/Propaganda Do AnyDesk 🧹

Script PowerShell para localizar e remover automaticamente os arquivos de configuração que geram propagandas no AnyDesk.

## 🚀 Execução Remota (One-Liner)

Abra o **PowerShell como Administrador** e execute:

```powershell
irm https://raw.githubusercontent.com/Pugn0/remove-ads-anydesk/main/remover_ads_anydesk.ps1 | iex
```

> O script detecta automaticamente a execução remota e roda sem pedir confirmação.

## 💻 Execução Local

1. Baixe o repositório
2. Execute `iniciar.bat` como **Administrador**, ou:

```powershell
PowerShell -ExecutionPolicy Bypass -File remover_ads_anydesk.ps1
```

No modo local, um menu interativo será exibido com opções de visualizar e apagar arquivos.

## 🔧 O que o script faz

- Localiza a pasta `AnyDesk` em `%APPDATA%`
- Remove **todos os arquivos** exceto:
  - `user.conf` (configurações do usuário)
  - Pasta `thumbnails/`
- Exibe resumo do que foi removido

## ⚠️ Aviso

Este script **não desinstala o AnyDesk**, apenas remove arquivos de configuração que geram propagandas. Use com responsabilidade.

## 📋 Modos de execução

| Modo | Comando | Comportamento |
|------|---------|---------------|
| Remoto | `irm URL \| iex` | Executa automaticamente sem confirmação |
| Local | `.bat` ou `-File` | Menu interativo com confirmação |

---

### 👤 Créditos

Desenvolvido por [Pugno](https://t.me/pugno_fc)
