param([bool]$Apply = $false)
foreach ($folder in $script:Settings.Paths.Folders) {
    $root = [System.IO.Path]::GetPathRoot($folder)
    if (!(Test-Path -LiteralPath $root)) { Write-Log "SKIP missing drive $root for $folder" 'WARN'; continue }
    if (!$Apply) { Write-Log "DRY RUN: mkdir $folder"; continue }
    if (!(Test-Path -LiteralPath $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null; Write-Log "Created $folder" }
    else { Write-Log "Already exists: $folder" }
}
Show-Manual 'Downloads/Documents are NOT relocated automatically. Use Properties > Location > Move, after checking OneDrive settings.'
Show-Manual 'Do not relocate C:\Users, AppData, TEMP or pagefile to HDD for SSD lifespan alone.'
