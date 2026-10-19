[CmdletBinding()]
param(
  [ValidateSet('All','System','Storage','General','Development','AI','Audio','Validate')]
  [string[]]$Phase = @('All'),
  [switch]$Apply
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts/common.ps1')
$phases = [ordered]@{
  'System'='01-system.ps1'; 'Storage'='02-storage.ps1'; 'General'='03-general.ps1';
  'Development'='04-development.ps1'; 'AI'='05-ai.ps1'; 'Audio'='06-audio.ps1'; 'Validate'='07-validate.ps1'
}
if ($Phase -contains 'All') { $Phase = @($phases.Keys) }
Write-Log "BOOTSTRAP START | Mode=$(if ($Apply) {'APPLY'} else {'DRY RUN'}) | Phases=$($Phase -join ',')"
foreach ($key in $phases.Keys) {
  if ($Phase -notcontains $key) { continue }
  $path = Join-Path $PSScriptRoot "scripts/$($phases[$key])"
  Invoke-Step $key { & $path -Apply ([bool]$Apply) }
}
if ($script:Failures.Count -gt 0) {
  Write-Log "BOOTSTRAP END WITH $($script:Failures.Count) FAILED PHASE(S)" 'ERROR'
  $script:Failures | ForEach-Object { Write-Log $_ 'ERROR' }
  exit 1
}
Write-Log 'BOOTSTRAP FINISHED SUCCESSFULLY (manual actions may remain).'
