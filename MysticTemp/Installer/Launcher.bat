@echo off
chcp 65001>nul
title Mystic Launcher 启动器
:admincheck
net session >nul 2>&1
if %errorlevel% neq 0 (
    PowerShell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)
set /p path=<"%appdata%\MysticClient\instpath.txt"
start "" "%path%Launcher.exe"
exit