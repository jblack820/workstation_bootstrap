param([bool]$Apply = $false)
foreach ($cmd in @('winget','git','java','node','npm','docker','ollama','code')) {
    $found = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($found) { Write-Log "FOUND: $cmd => $($found.Source)" }
    else { Write-Log "NOT FOUND (may require restart/new shell): $cmd" 'WARN' }
}
foreach ($drive in @('C:','D:','E:')) {
    if (Test-Path "$drive\") {
        $d = Get-PSDrive -Name $drive.TrimEnd(':') -ErrorAction SilentlyContinue
        if ($d -and $null -ne $d.Free) { Write-Log "DRIVE: $drive free $([math]::Round($d.Free / 1GB,1)) GiB" }
    }
}
Show-Manual 'Verify Device Manager, Docker WSL backend, IntelliJ JDK, GitHub SSH and Cubase/RME ASIO in GUI.'
Show-Manual 'Take a system image and back up projects, licenses and recovery keys separately.'
