param([bool]$Apply = $false)
Write-Log 'Checking Windows and prerequisites'
if ($PSVersionTable.PSVersion.Major -lt 5) { throw 'PowerShell 5.1+ required' }
Write-Log "PowerShell version: $($PSVersionTable.PSVersion)"
Write-Log "OS: $([System.Environment]::OSVersion.VersionString)"
if (Get-Command winget -ErrorAction SilentlyContinue) { Write-Log 'WinGet available' } else { Write-Log 'WinGet not found; install/update App Installer' 'WARN' }
Show-Manual 'Run Windows Update, reboot until current, and activate Windows 11 Pro.'
Show-Manual 'Install verified ASUS chipset/LAN/Wi-Fi/GPU drivers as needed; inspect Device Manager.'
Show-Manual 'Back up your BitLocker recovery key before drive or firmware changes.'
Show-Manual 'Do not automate BIOS updates or storage repartitioning.'
