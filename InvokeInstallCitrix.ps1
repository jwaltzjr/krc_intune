$ScriptUrl="https://raw.githubusercontent.com/jwaltzjr/krc_intune/master/InstallCitrix.ps1"
$ScriptName="Install Citrix"

$psCommand= "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -command $([char]34)& {(Invoke-WebRequest $ScriptUrl).Content | Invoke-Expression}$([char]34)"
$regKeyLocation="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
if (!(Test-Path -Path $regKeyLocation)){
    New-ItemProperty -Path $regKeyLocation -Force
}
Set-ItemProperty -Path $regKeyLocation -Name $ScriptName -Value $psCommand -Force
Invoke-Expression $psCommand
