---
name: omniget
description: >
  MUST USE AUTOMATICALLY whenever the user wants to use OmniGet or omniget-cli to download courses
  (Hotmart, Udemy, Kiwify, Skool), videos, audio (MP3/M4A/FLAC), image galleries, or torrents from
  1,800+ sites, inspect media metadata, archive channels, or interact with OmniGet's local MCP bridge.
  Triggers autonomously when "omniget", "/omniget", "baixar curso", "captura global Ctrl+Shift+D", or
  advanced multi-platform media extraction is requested.
---

# OmniGet - Universal Media, Course & Torrent Extractor Skill

## 1. Objetivo Principal
Orquestrar a extração local de vídeos, áudios, cursos fechados (com cookies gerenciados do navegador), galerias de imagens e torrents utilizando o ecossistema **OmniGet v0.15.0** (`omniget-cli.exe` e `OmniGet.exe`) 100% parametrizado com validação **SHA-256** e integração **FreeLLMAPI / Ollama**.

## 2. Gatilhos Operacionais
- Menções diretas a `OmniGet`, `omniget-cli` ou ao comando `/omniget`.
- Solicitações de download ou arquivamento de cursos de plataformas autenticadas (Hotmart, Udemy, Kiwify, Skool, Rocketseat, Alura, Coursera, Domestika).
- Extração de vídeos, áudios, legendas, metadados ou galerias de mais de 1.800 sites com remoção automática de patrocínios (SponsorBlock).
- Reaplicação de parametrização ou diagnóstico de motores (`yt-dlp`, `FFmpeg`, `gallery-dl`).

## 3. Diretrizes de Execução Passo a Passo

### Passo 1: Caminhos Padronizados da Instalação
- **Diretório Raiz do Projeto:** `C:\Users\Home\.gemini\antigravity\scratch\omniget`
- **Executável Desktop Portátil:** `C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\OmniGet.exe`
- **CLI Nativa:** `C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\omniget-cli.exe`
- **Script de Parametrização e Auditoria SHA-256:** `C:\Users\Home\.gemini\antigravity\scratch\omniget\setup-omniget.ps1`
- **Diretório Padrão de Saída:** `C:\Users\Home\.gemini\antigravity\scratch\Downloads`
- **Bridge MCP Local:** `http://127.0.0.1:47720/mcp` (Bearer: `omniget-local-bridge-token-2026`)

### Passo 2: Execução de Comandos via `omniget-cli`

1. **Inspeção Rápida de Metadados (sem baixar arquivo):**
   ```powershell
   & "C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\omniget-cli.exe" info "<URL>"
   ```

2. **Download de Vídeo em Qualidade Máxima (MP4 com FFmpeg Muxing):**
   ```powershell
   & "C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\omniget-cli.exe" download "<URL>" -o "C:\Users\Home\.gemini\antigravity\scratch\Downloads"
   ```

3. **Extração Isolada de Áudio + Legendas (PT/EN):**
   ```powershell
   & "C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\omniget-cli.exe" download "<URL>" --audio-only --subs pt,en -o "C:\Users\Home\.gemini\antigravity\scratch\Downloads"
   ```

4. **Download em Lote (Batch) com Controle de Concorrência:**
   ```powershell
   & "C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\omniget-cli.exe" batch "<CAMINHO_ARQUIVO_TXT>" -m 3 -o "C:\Users\Home\.gemini\antigravity\scratch\Downloads"
   ```

5. **Importação de Cookies para Cursos e Conteúdos Restritos:**
   ```powershell
   & "C:\Users\Home\.gemini\antigravity\scratch\omniget\dist\omniget-cli.exe" import-cookies "<CAMINHO_COOKIES_TXT>"
   ```

6. **Verificação e Reaplicação da Parametrização 100%:**
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Home\.gemini\antigravity\scratch\omniget\setup-omniget.ps1"
   ```

## 4. Exemplos e Saídas Esperadas
- Ao finalizar qualquer operação de download ou diagnóstico, apresente ao usuário:
  1. O caminho absoluto clicável do arquivo gerado em `C:\Users\Home\.gemini\antigravity\scratch\Downloads`.
  2. O tamanho do arquivo e o status da validação SHA-256 dos motores utilizados.
