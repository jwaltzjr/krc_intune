$Url = "https://downloads.citrix.com/18632/CitrixWorkspaceApp.exe?__gda__=1600745047_0e65890719326c138dbfbbee451186b5"
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
