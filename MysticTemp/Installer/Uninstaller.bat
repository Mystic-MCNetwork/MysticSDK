@echo off
chcp 65001>nul
title Mystic Client 卸载器
:admincheck
net session >nul 2>&1
if %errorlevel% neq 0 (
    PowerShell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)
if not exist "%appdata%\MysticClient\instpath.txt" exit
where powershell > "%TEMP%\POWERSHELL_PATH.txt"
set /p pspath=<"%TEMP%\POWERSHELL_PATH.txt"
set /p path=<"%appdata%\MysticClient\instpath.txt"
echo 请不要关闭本窗口,否则可能会导致卸载失败!
echo Mystic Client安装路径: %path%
echo.
where powershell|find "powershell.exe" >nul&&goto uninstall||goto nopowershell
:nopowershell
set pspath=%systemdrive%\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
echo [+]启动失败！未检测到Powershell！(怎么可能...)
echo [+]脚本将使用默认路径...(%pspath%)
if not exist "%pspath%" goto norealpowershell
echo.
echo [+]已找到默认路径下的Powershell!
echo.
goto uninstall
:norealpowershell
echo.
echo [+]启动失败！您的电脑未安装Powershell！
echo [+]将在10秒内自动退出...(按任意键也可以退出)
timeout 10>nul
exit
:checks
"%systemdrive%\windows\system32\tasklist.exe"|find "java.exe" >nul&&goto running||goto uninstall
"%systemdrive%\windows\system32\tasklist.exe"|find "javaw.exe" >nul&&goto running||goto uninstall
:running
echo.
echo 注意:
echo  检测到疑似游戏的java进程，若保持游戏运行，可能会导致安装失败。
echo  按下任意键继续卸载...
pause>nul
:uninstall
%pspath% -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('是否卸载Mystic Client?', 'Mystic Client 卸载器', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
if %OUT%==No (exit)
taskkill /f /im java.exe
taskkill /f /im javaw.exe
taskkill /f /im Launcher.exe
del /f /s /q "%path%*.*"
del /f /s /q "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client\Mystic Client.lnk"
del /f /s /q "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client\卸载Mystic Client.lnk"
del /f /s /q "%userprofile%\Desktop\Mystic Client.lnk"
del /f /s /q "%appdata%\MysticClient\instpath.txt"
del /f /s /q "%appdata%\MysticClient\Launcher.bat"
del /f /s /q "%appdata%\MysticClient\Icon.ico"
%pspath% -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Mystic Client Uninstaller', 'Mystic Client 已卸载成功，感谢您的使用。', [System.Windows.Forms.ToolTipIcon]::None)}"
del /f /s /q "%appdata%\MysticClient\Uninstaller.bat" & exit