param([bool]$Apply = $false)
if ($script:Settings.EnableWSL) {
    if ($Apply) { Show-Manual 'WSL is enabled in settings; execute wsl --install manually from an elevated terminal, then reboot and configure Docker.' }
    else { Write-Log 'DRY RUN: WSL installation requested (manual admin action)' }
}
Install-PackageGroup 'Development' $Apply
Show-Manual 'Use project Maven/Gradle wrappers, not an unnecessary global install.'
Show-Manual 'Install the project-specific Angular CLI version (prefer local devDependency) and additional JDKs only if required.'
Show-Manual 'Docker Desktop requires compatible WSL 2/virtualization and possibly admin approval.'
Show-Manual 'Set up GitHub SSH and clone repositories only after verifying permissions.'
