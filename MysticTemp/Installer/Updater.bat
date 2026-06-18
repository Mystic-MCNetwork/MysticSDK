@echo off
chcp 65001>nul
:admincheck
net session >nul 2>&1
if %errorlevel% neq 0 (
    PowerShell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)
where powershell> "%TEMP%\POWERSHELL_PATH.txt"
set /p pspath=<"%TEMP%\POWERSHELL_PATH.txt"
where powershell|find "powershell.exe" >nul&&goto updatestart||goto nopowershell
:nopowershell
set pspath=%systemdrive%\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
echo [+]启动失败！未检测到Powershell！(怎么可能...)
echo [+]将使用默认路径...(%pspath%)
if not exist "%pspath%" goto norealpowershell
echo.
echo [+]已找到默认路径下的Powershell!
echo.
:updatestart
"%systemdrive%\windows\system32\taskkill.exe" /f /im Launcher.exe
"%systemdrive%\windows\system32\taskkill.exe" /f /im javaw.exe
"%systemdrive%\windows\system32\taskkill.exe" /f /im java.exe
set /p updatepath=<"%appdata%\MysticClient\instpath.txt"
del /f /s /q "%updatepath%.minecraft\versions\Mystic Client.jar"
del /f /s /q "%updatepath%.minecraft\versions\Mystic Client.json"
del /f /s /q "%updatepath%.minecraft\versions\MysticClient\mods"
del /f /s /q "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client\Mystic Client.lnk"
del /f /s /q "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client\卸载Mystic Client.lnk"
del /f /s /q "%userprofile%\Desktop\Mystic Client.lnk"
del /f /s /q "%appdata%\MysticClient\Launcher.bat"
del /f /s /q "%appdata%\MysticClient\Icon.ico"
copy "%~dp0Package\Game" "%updatepath%.minecraft\versions\Mystic Client"
copy "%~dp0Package\Mods" "%updatepath%.minecraft\versions\Mystic Client\mods"
copy "%~dp0Package\Launcher_Configs" "%updatepath%PCL"
copy "%~dp0Package\Links" "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client"
copy "%~dp0Package\Links\Mystic Client.lnk" "%userprofile%\Desktop"
copy "%~dp0Launcher.bat" "%appdata%\MysticClient"
copy "%~dp0Uninstaller.bat" "%appdata%\MysticClient"
copy "%~dp0Icon.ico" "%appdata%\MysticClient"
copy "%~dp0Package\Launcher.exe" "%updatepath%"
%pspath% -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Mystic Client Installer', 'Mystic Client 已更新成功，请享受！', [System.Windows.Forms.ToolTipIcon]::None)}"
del /f /s /q "%~dp0Package\*.*"
del /f /s /q "%temp%\MysticTemp\*.*"
del /f /s /q "%~dp0Icon.ico"
del /f /s /q "%~dp0Launcher.bat"
del /f /s /q "%~dp0Uninstaller.bat"
del /f /s /q "%~dp0Installer.bat"
del /f /s /q "%~dp0Updater.bat" & exit