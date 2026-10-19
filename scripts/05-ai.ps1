param([bool]$Apply = $false)
Install-PackageGroup 'AI' $Apply
if ($script:Settings.DownloadOllamaModel) {
    if ($Apply) {
        if (Get-Command ollama -ErrorAction SilentlyContinue) {
            & ollama pull $script:Settings.OllamaModel
            if ($LASTEXITCODE -ne 0) { throw 'Ollama model download failed' }
        } else { Show-Manual 'Ollama CLI not yet in current PATH; open a new terminal and run ollama pull manually.' }
    } else { Write-Log "DRY RUN: ollama pull $($script:Settings.OllamaModel)" }
}
Show-Manual 'Install IntelliJ plugins: Continue, Copilot, JetBrains AI, Cline. Authorize each account manually.'
Show-Manual 'Codex CLI/Desktop installation and provider tokens are intentionally manual; never store API keys in repository.'
