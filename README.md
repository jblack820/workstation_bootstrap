# Windows 11 Pro Workstation Bootstrap (v0.1)

Modular PowerShell + WinGet bootstrap for a Java/Angular/AI/Cubase workstation.

## Before you start

1. Install Windows 11 Pro, install Windows updates, reboot, verify Windows activation.
2. Back up existing data, BitLocker recovery key, and software licenses.
3. Check drive letters: the examples assume **C:** = system NVMe, **D:** = audio SSD, **E:** = archive HDD. Edit `config/settings.json` if different.
4. Run in an ordinary PowerShell session with your normal user account. Individual installers can prompt for elevation. Do not run arbitrary downloaded scripts as administrator.
5. Read `config/packages.json`. Optional entries have `"enabled": false`. Package IDs should be rechecked with `winget show --id PACKAGE.ID --exact` before first use.

## Start

Open PowerShell, enter the extracted folder:

```powershell
cd C:\path\to\windows-bootstrap
.\bootstrap.ps1                  # Preview only; nothing installed
.\bootstrap.ps1 -Phase Storage  # Preview one phase
.\bootstrap.ps1 -Phase General,Development -Apply
.\bootstrap.ps1 -Apply           # Run all phases
```

If script execution is blocked, review the files first, then use `Set-ExecutionPolicy -Scope Process RemoteSigned` in this PowerShell session, or consult your security policy. Do not disable security globally.

## What the phases do

- `01-system.ps1`: checks prerequisites and lists manual OS/driver actions.
- `02-storage.ps1`: creates folders on existing drives; **never** partitions disks or redirects user folders automatically.
- `03-general.ps1`: 7-Zip, Chrome, VS Code, PowerShell 7, Git, VLC.
- `04-development.ps1`: JDK 17, IntelliJ IDEA Ultimate, Node.js LTS, Docker Desktop; WSL setup noted, not automatically elevated.
- `05-ai.ps1`: Ollama; model download opt-in via settings.
- `06-audio.ps1`: manual workflow for RME, Steinberg, Native Instruments, VSL.
- `07-validate.ps1`: detects common CLIs, checks existing drives, outputs manual validation tasks.

## Design notes

- Default mode is **dry run**. `-Apply` enables actual installation and folder creation.
- `winget install --no-upgrade` avoids automatic upgrades of already installed packages, and installations may still request UAC/interaction.
- A package failure causes that phase to fail, but later phases are still attempted; see daily log in `logs/`.
- This starter does not automatically move Documents/Downloads, install sound drivers, modify registry, disable Windows Defender, manage credentials, or reboot Windows.
- This project has **not been executed or tested on the target Windows PC**. Carefully test in dry-run mode first.
- For true reproducibility later: pin program versions; add package detection, retries, machine-specific profiles, and per-package status reporting.
- The scripts should be stored in Git **without** API keys, SSH private keys, license keys, or personal documents.

## Sources

- Microsoft WinGet installation flags: https://learn.microsoft.com/en-us/windows/package-manager/winget/install
