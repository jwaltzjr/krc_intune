$Url = "https://downloadplugins.citrix.com/Windows/CitrixWorkspaceApp.exe"
$Target = "$env:SystemRoot\Temp\CitrixWorkspaceApp.exe"
$Arguments = 'DONOTSTARTCC=1 /AutoUpdateCheck=Auto /AutoUpdateStream=LTSR /DeferUpdateCount=3 /AURolloutPriority=Slow /NoReboot /Silent EnableCEIP=False'
$ScriptName="Install Citrix"
$regKeyLocation="HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"

if (!(Test-Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Citrix\PluginPackages\XenAppSuite\ICA_Client)) {
    Write-Host "Citrix not installed - downloading"
    Start-BitsTransfer -Source $Url -Destination $Target -Priority High -TransferPolicy Always -ErrorAction Continue
    $t = Start-Process -FilePath $Target -ArgumentList $Arguments -PassThru -ErrorAction Stop
    if($t -ne $null)
    {
       Wait-Process -InputObject $t
    }
}
else {
    Write-Host "Citrix installed"
    Remove-ItemProperty -Path $regKeyLocation -Name $ScriptName -Force
}
