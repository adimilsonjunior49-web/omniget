<#
.SYNOPSIS
    Script de Instalação e Parametrização 100% do OmniGet v0.15.0 (Windows).
.DESCRIPTION
    1. Desbloqueia binários contra alertas do Windows Defender SmartScreen (Unblock-File).
    2. Valida os hashes SHA-256 dos motores (OmniGet, omniget-cli, yt-dlp, ffmpeg, ffprobe, gallery-dl).
    3. Aplica a parametrização completa (settings.json, ai_config.json, ai-keys.json, binary-overrides.json)
       tanto no diretório Portátil (dist/data) quanto no AppData do sistema (%APPDATA%\com.openselena.omniget).
    4. Registra o diretório de binários no PATH do usuário para uso global do omniget-cli.
#>
[CmdletBinding()]
param(
    [switch]$LaunchApp
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$DistDir = Join-Path $RepoRoot "dist"
$PortableDataDir = Join-Path $DistDir "data"
$AppDataDir = Join-Path $env:APPDATA "com.openselena.omniget"
$ConfigSrcDir = Join-Path $RepoRoot "config"
$DownloadsDir = "C:\Users\Home\.gemini\antigravity\scratch\Downloads"

Write-Host "==> [1/5] Criando estrutura de diretórios do OmniGet..." -ForegroundColor Cyan
foreach ($dir in @($DistDir, "$PortableDataDir\bin", "$PortableDataDir\tools", "$AppDataDir\bin", "$AppDataDir\tools", $DownloadsDir)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Garantir arquivo marcador de modo portátil
New-Item -ItemType File -Path (Join-Path $DistDir "portable.txt") -Force | Out-Null

Write-Host "==> [2/5] Sincronizando configurações 100% parametrizadas..." -ForegroundColor Cyan
foreach ($targetData in @($PortableDataDir, $AppDataDir)) {
    Copy-Item (Join-Path $ConfigSrcDir "settings.json") (Join-Path $targetData "settings.json") -Force
    Copy-Item (Join-Path $ConfigSrcDir "ai_config.json") (Join-Path $targetData "ai_config.json") -Force
    Copy-Item (Join-Path $ConfigSrcDir "binary-overrides.json") (Join-Path $targetData "binary-overrides.json") -Force
    Copy-Item (Join-Path $ConfigSrcDir "ai-keys.json") (Join-Path $targetData "tools\ai-keys.json") -Force
}

Write-Host "==> [3/5] Removendo bloqueios de primeiro boot (SmartScreen / Mark of the Web)..." -ForegroundColor Cyan
Get-ChildItem -Path $DistDir -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue
Get-ChildItem -Path $AppDataDir -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue

Write-Host "==> [4/5] Validando integridade criptográfica SHA-256 dos motores..." -ForegroundColor Cyan
$ShaFile = Join-Path $DistDir "SHA256SUMS.txt"
if (Test-Path $ShaFile) {
    $lines = Get-Content $ShaFile | Where-Object { $_.Trim() -ne "" }
    foreach ($line in $lines) {
        $parts = $line -split "\s+", 2
        $expectedHash = $parts[0].Trim().ToLower()
        $fileName = $parts[1].Trim()
        $candidatePaths = @(
            (Join-Path $DistDir $fileName),
            (Join-Path "$PortableDataDir\bin" $fileName)
        )
        foreach ($p in $candidatePaths) {
            if (Test-Path $p) {
                $actualHash = (Get-FileHash -Path $p -Algorithm SHA256).Hash.ToLower()
                if ($actualHash -eq $expectedHash) {
                    Write-Host "    [OK] $fileName ($actualHash)" -ForegroundColor Green
                } else {
                    Write-Warning "    [ALERTA] Hash divergente para $fileName! Esperado: $expectedHash | Atual: $actualHash"
                }
                break
            }
        }
    }
}

Write-Host "==> [5/6] Verificando registro do omniget-cli no PATH do usuário..." -ForegroundColor Cyan
$UserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$DistDir*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$UserPath;$DistDir", "User")
    $env:Path += ";$DistDir"
    Write-Host "    [OK] Diretório $DistDir adicionado ao PATH do usuário." -ForegroundColor Green
} else {
    Write-Host "    [OK] Diretório $DistDir já consta no PATH do usuário." -ForegroundColor Green
}

Write-Host "==> [6/6] Criando atalho na Área de Trabalho (Desktop)..." -ForegroundColor Cyan
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "OmniGet.lnk"
$TargetExe = Join-Path $DistDir "OmniGet.exe"
if (Test-Path $TargetExe) {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetExe
    $Shortcut.WorkingDirectory = $DistDir
    $Shortcut.IconLocation = "$TargetExe,0"
    $Shortcut.Description = "OmniGet v0.15.0 - Gerenciador de Downloads Universal (100% Parametrizado)"
    $Shortcut.Save()
    Write-Host "    [OK] Atalho criado em: $ShortcutPath" -ForegroundColor Green
}

Write-Host "`n[SUCESSO] OmniGet v0.15.0 instalado e 100% parametrizado!" -ForegroundColor Green
if ($LaunchApp -and (Test-Path (Join-Path $DistDir "OmniGet.exe"))) {
    Write-Host "==> Iniciando OmniGet Desktop..." -ForegroundColor Yellow
    Start-Process -FilePath (Join-Path $DistDir "OmniGet.exe") -WorkingDirectory $DistDir
}
