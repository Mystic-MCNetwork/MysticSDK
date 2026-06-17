@echo off
chcp 65001>nul
:admincheck
net session >nul 2>&1
if %errorlevel% neq 0 (
    PowerShell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)
:removetemp
del /f /s /q "%temp%\MysticClient\InstallMode.txt"
cls
:start
title Mystic Client 预安装检测
echo  ==========================================================
echo   请无论如何都不要关闭此窗口，否则Mystic Client会安装失败!
echo  ==========================================================
echo 正在检测Windows版本...
echo.
ver|find "10.0." >nul&&set ver=10||set ver=not10
if %ver%==not10 goto nowindows
echo 正在检测是否存在已安装的Mystic Client...
echo.
if exist "%appdata%\MysticClient\instpath.txt" goto installed
start "" "%~dp0Installer.exe"
exit
:installed
set /p path=<"%appdata%\MysticClient\instpath.txt"
echo 检测到您已安装Mystic Client,请指定安装器接下来的操作.
echo 已安装Mystic Client路径: %path%
echo 安装器缓存文件路径: %~dp0
echo.
echo  1 - 更新我的 Mystic Client
echo  2 - 卸载 Mystic Client
echo.
set /p input=请输入操作序号,并回车: 
echo.
if %input%==1 goto first
if %input%==2 goto second
echo  您输入的序号有误!
echo.
goto installed
:first
start "" "%~dp0Installer.exe"
del /f /s /q "%~dp0Notify.bat"
del /f /s /q "%~dp0UniversalChecks.bat" & exit
:second
start "" "%appdata%\MysticClient\Uninstaller.bat"
goto cleartemp
:nowindows
echo 您的Windows版本低于10,请更新您的Windows后再安装Mystic Client.
echo 预安装检测器将在10秒内自动退出...(按任意键也可以退出)
timeout 10>nul
goto cleartemp
:cleartemp
echo Mystic Client 安装器正在清理缓存...
del /f /s /q %~dp0*.* & exit

