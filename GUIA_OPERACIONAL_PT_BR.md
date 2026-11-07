# Guia Operacional e de Implantação: OmniGet v0.15.0 (100% Parametrizado)

Este repositório contém a implantação parametrizada do **OmniGet v0.15.0** (licença **GPL-3.0**, execução 100% local, zero telemetria externa), pré-configurada com motores validados via **SHA-256**, atalhos globais ativos, integração com **FreeLLMAPI / Ollama** e servidor **MCP Local**.

---

## 1. Arquitetura e Garantias de Segurança (SHA-256)

Todos os binários embutidos e gerenciados foram desbloqueados no Windows SmartScreen (`Unblock-File`) e validados criptograficamente:

| Binário | Função | SHA-256 Verificado |
| :--- | :--- | :--- |
| `OmniGet.exe` | Aplicativo Desktop Portátil (Tauri 2 / Rust) | `a83655b4c49915fe4a1d85e28130812c7e0efa9eb9e8eaea20d584c6371d22c1` |
| `omniget-cli.exe` | Interface de Linha de Comando Nativa | `67aa89b2996bfe035f58533232ed5de30acff574b58c989c2b9b4e3b9c660fdf` |
| `yt-dlp.exe` | Motor de Extração Universal (1.800+ sites) | `66674953fe251b89f4d08c5f0e35e0728679bd67ab3d7d05c0562af101dd3e7a` |
| `ffmpeg.exe` | Multiplexação de Vídeo/Áudio e Conversão | `09948d4cdd0650da6ff5a87577469f2a218dc2615ae379f8f734d24c49de0f73` |
| `ffprobe.exe` | Inspeção de Fluxos e Metadados de Mídia | `a6618e99bb58869ded3c6f37b53aa1a8d701c3591dbb7b5b317d47369c112be2` |
| `gallery-dl.exe` | Extração de Galerias e Carrosséis (250+ sites) | `77c8f4c6808cf1044a54ec7187b548f5977f7c304d5432b63cf6cfdfe70ffc12` |

---

## 2. Parâmetros Pré-Configurados (`config/settings.json`)

A instalação aplica automaticamente a configuração nos diretórios **Portátil** (`dist/data/`) e **Sistema** (`%APPDATA%\com.openselena.omniget\`):

- **Idioma e Interface:** Português do Brasil (`pt`), tema escuro (`dark`), telas de primeiro boot e aviso legal já confirmadas (`onboarding_completed: true`).
- **Diretório Padrão de Saída:** `C:\Users\Home\.gemini\antigravity\scratch\Downloads` (organizado por plataforma).
- **Atalhos Globais Ativados:**
  - `Ctrl + Shift + D` (`Cmd + Shift + D` no macOS): Captura universal de link da área de transferência (vídeo, curso, galeria ou magnet link).
  - `Ctrl + Shift + M` (`Cmd + Shift + M` no macOS): Extração direta de áudio em **MP3**.
  - `Ctrl + Shift + B` (`Cmd + Shift + B` no macOS): Captura rápida de clipe.
- **Qualidade e Pós-Processamento:**
  - Vídeo na melhor qualidade disponível (`best`) com mescla automática via `FFmpeg`.
  - Miniatura (`embed_thumbnail`), metadados (`embed_metadata`) e legendas em português (`pt`) embutidos.
  - Remoção automática de trechos patrocinados no YouTube via **SponsorBlock** (`sponsor`, `selfpromo`, `interaction`).
- **Cursos Fechados (Hotmart, Udemy, Kiwify, Skool):**
  - Importação automática de cookies do navegador (`cookies_from_browser: "chrome"`).
  - Numeração sequencial contínua de aulas (`continuous_lecture_numbers: true`).
- **Rede e BitTorrent:**
  - 16 fragmentos simultâneos por download, 3 downloads paralelos, prevenção de suspensão do sistema (`prevent_sleep: true`).
  - Cliente BitTorrent integrado na porta `6881` com UPnP e auto-trackers ativos.
- **Inteligência Artificial Local (Custo Zero) e MCP Server:**
  - Roteador **FreeLLMAPI** (`http://localhost:3001/v1`, modelo `auto`) e **Ollama Local** (`http://localhost:11434/v1`, modelo `qwen2.5:3b`) pré-cadastrados em `ai_config.json` e `tools/ai-keys.json`.
  - Bridge HTTP/MCP ativo em `http://127.0.0.1:47720/mcp` com token `omniget-local-bridge-token-2026`.

---

## 3. Resolução de Avisos de Segurança de Primeiro Boot

### Windows (`.exe` portátil)
O script `setup-omniget.ps1` já remove automaticamente o atributo *Mark of the Web* (`Zone.Identifier`) via `Unblock-File`. Caso execute em outra máquina e o SmartScreen exiba *"O Windows protegeu o seu computador"*:
1. Clique em **Mais informações** (*More info*).
2. Clique em **Executar assim mesmo** (*Run anyway*), ou rode no PowerShell:
   ```powershell
   Unblock-File -Path .\dist\OmniGet.exe
   ```

### macOS (`.dmg`)
Para liberar o aplicativo no Gatekeeper após movê-lo para `/Applications`:
```bash
xattr -cr /Applications/omniget.app
codesign --force --deep --sign - /Applications/omniget.app
```

### Linux (`Flatpak` / `AppImage` / `.deb`)
```bash
# Permissão de acesso à pasta Downloads via Flatpak
flatpak override --user --filesystem=xdg-download org.omniget.OmniGet
```

---

## 4. Comandos Rápidos (`omniget-cli` e Script de Setup)

### Reaplicar Parametrização 100%
```powershell
powershell -ExecutionPolicy Bypass -File .\setup-omniget.ps1
```

### Uso via Linha de Comando (`omniget-cli`)
```powershell
# Inspecionar metadados e formatos sem baixar
.\dist\omniget-cli.exe info "<URL>"

# Baixar vídeo em qualidade máxima
.\dist\omniget-cli.exe download "<URL>" -o "C:\Users\Home\.gemini\antigravity\scratch\Downloads"

# Extrair apenas áudio e legendas em português
.\dist\omniget-cli.exe download "<URL>" --audio-only --subs pt,en

# Download em lote a partir de arquivo .txt (3 simultâneos)
.\dist\omniget-cli.exe batch links.txt -m 3
```
