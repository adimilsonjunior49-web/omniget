@echo off
chcp 65001 >nul
echo ========================================================
echo   OmniGet v0.15.0 - Inicializador 100%% Parametrizado
echo ========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-omniget.ps1" -LaunchApp
