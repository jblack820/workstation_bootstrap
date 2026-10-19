Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:ProjectRoot = Split-Path -Parent $PSScriptRoot
$script:Settings = Get-Content (Join-Path $script:ProjectRoot 'config/settings.json') -Raw | ConvertFrom-Json
$script:Packages = Get-Content (Join-Path $script:ProjectRoot 'config/packages.json') -Raw | ConvertFrom-Json
$script:LogDir = Join-Path $script:ProjectRoot 'logs'
if (!(Test-Path $script:LogDir)) { New-Item -ItemType Directory -Path $script:LogDir -Force | Out-Null }
$script:LogFile = Join-Path $script:LogDir ("bootstrap-{0}.log" -f (Get-Date -Format 'yyyyMMdd'))
$script:Failures = [System.Collections.Generic.List[string]]::new()
function Write-Log([string]$Text, [string]$Level = 'INFO') {
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format 's'), $Level, $Text
    Write-Host $line
    Add-Content -Path $script:LogFile -Value $line -Encoding UTF8
}
function Invoke-Step([string]$Title, [scriptblock]$Action) {
    Write-Log "START: $Title"
    try { & $Action; Write-Log "END: $Title" }
    catch { $script:Failures.Add("${Title}: $($_.Exception.Message)"); Write-Log "FAILED: $Title - $($_.Exception.Message)" 'ERROR' }
}
function Require-Winget {
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) { throw 'WinGet unavailable. Update App Installer from Microsoft Store and retry.' }
}
function Install-PackageGroup([string]$GroupName, [bool]$Apply) {
    Require-Winget
    $group = $script:Packages.PSObject.Properties[$GroupName]
    if ($null -eq $group) { throw "Unknown package group: $GroupName" }
    foreach ($item in $group.Value) {
        if ($item.PSObject.Properties.Name -contains 'enabled' -and $item.enabled -eq $false) { Write-Log "SKIP disabled: $($item.name)"; continue }
        $id = [string]$item.id
        if ($id -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]+$') { throw "Unsafe package ID: $id" }
        if (!$Apply) { Write-Log "DRY RUN: winget install --id $id --exact --source winget --no-upgrade"; continue }
        Write-Log "Installing: $($item.name) ($id)"
        & winget install --id $id --exact --source winget --no-upgrade --accept-package-agreements --accept-source-agreements --disable-interactivity
        if ($LASTEXITCODE -ne 0) { throw "WinGet failed for $id (exit code: $LASTEXITCODE)" }
    }
}
function Show-Manual([string]$Message) { Write-Log "MANUAL: $Message" 'ACTION' }
