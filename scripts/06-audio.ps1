param([bool]$Apply = $false)
Install-PackageGroup 'Audio' $Apply
Show-Manual 'RME HDSP AIO: download the matching driver/TotalMix from the official RME site; reboot and verify ASIO.'
Show-Manual 'Steinberg Download Assistant, Activation Manager, Cubase: install and sign in manually.'
Show-Manual 'Native Access/Kontakt, Vienna Assistant/Synchron and licensed VST plugins require manual sign-in and library paths.'
Show-Manual 'Put large libraries on the dedicated SSD; restore Cubase templates/preferences from your backup.'
