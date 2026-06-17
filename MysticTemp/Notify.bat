@echo off
chcp 65001>nul
title 解压通知
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Mystic Client Installer', '安装程序正在解压文件，请坐和放宽，我们即将完成解压。', [System.Windows.Forms.ToolTipIcon]::None)}"
exit