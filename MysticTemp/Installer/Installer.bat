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
where powershell|find "powershell.exe" >nul&&goto installationstart||goto nopowershell
:nopowershell
set pspath=%systemdrive%\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
echo [+]启动失败！未检测到Powershell！(怎么可能...)
echo [+]将使用默认路径...(%pspath%)
if not exist "%pspath%" goto norealpowershell
echo.
echo [+]已找到默认路径下的Powershell!
echo.
:installationstart
if exist "%appdata%\MysticClient\instpath.txt" goto updatestart
set path=%~dp0
mkdir "%appdata%\MysticClient"
echo %path%> "%appdata%\MysticClient\instpath.txt"
goto install
:install
del /f /s /q "%appdata%\MysticClient\Launcher.bat"
del /f /s /q "%appdata%\MysticClient\Uninstaller.bat"
mkdir "%path%.minecraft"
mkdir "%path%PCL"
mkdir "%path%.minecraft\versions\Mystic Client"
mkdir "%path%.minecraft\versions\Mystic Client\mods"
mkdir "%path%.minecraft\versions\Mystic Client\config"
copy "%~dp0Package\Launcher.exe" "%path%"
copy "%~dp0Package\Game\*.*" "%path%.minecraft\versions\Mystic Client"
copy "%~dp0Package\Mod_Configs" "%path%.minecraft\versions\Mystic Client\config\"
copy "%~dp0Package\Mods" "%path%.minecraft\versions\Mystic Client\mods"
copy "%~dp0Package\Launcher_Configs" "%path%PCL"
mkdir "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client"
copy "%path%\Package\Links" "%programdata%\Microsoft\Windows\Start Menu\Programs\Mystic Client"
copy "%path%\Package\Links\Mystic Client.lnk" "%userprofile%\Desktop"
copy "%path%\Launcher.bat" "%appdata%\MysticClient"
copy "%path%\Uninstaller.bat" "%appdata%\MysticClient"
copy "%path%\Icon.ico" "%appdata%\MysticClient"
%pspath% -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Mystic Client Installer', 'Mystic Client 已安装成功，请享受！', [System.Windows.Forms.ToolTipIcon]::None)}"
:cleartemp
del /f /s /q "%path%Package\*.*"
del /f /s /q "%temp%\MysticTemp\*.*"
del /f /s /q "%path%Icon.ico"
del /f /s /q "%path%Launcher.bat"
del /f /s /q "%path%Uninstaller.bat"
del /f /s /q "%path%Updater.bat"
del /f /s /q "%path%Installer.bat" & exit
exit
:updatestart
start "" "%~dp0Updater.bat"
exit