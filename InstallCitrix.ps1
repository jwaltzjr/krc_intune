$Url = "https://downloadplugins.citrix.com/Windows/CitrixWorkspaceApp.exe"
$Target = "$env:SystemRoot\Temp\CitrixWorkspaceApp.exe"
$Arguments = 'DONOTSTARTCC=1 /AutoUpdateCheck=Auto /AutoUpdateStream=LTSR /DeferUpdateCount=3 /AURolloutPriority=Slow /NoReboot /Silent EnableCEIP=False'

if (!(Test-Path -Path HKEY_CURRENT_USER\SOFTWARE\Citrix\ICA_Client)) {
    Start-BitsTransfer -Source $Url -Destination $Target -Priority High -TransferPolicy Always -ErrorAction Continue
    $t = Start-Process -FilePath $Target -ArgumentList $Arguments -PassThru -ErrorAction Stop
    if($t -ne $null)
    {
       Wait-Process -InputObject $t
    }
}
