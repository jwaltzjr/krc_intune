#region Functions
function Sync-SharepointLocation {
    param (
        [guid]$siteId,
        [guid]$webId,
        [guid]$listId,
        [mailaddress]$userEmail,
        [string]$webUrl,
        [string]$webTitle,
        [string]$listTitle,
        [string]$syncPath
    )
    try {
        Add-Type -AssemblyName System.Web
        #Encode site, web, list, url & email
        [string]$siteId = [System.Web.HttpUtility]::UrlEncode($siteId)
        [string]$webId = [System.Web.HttpUtility]::UrlEncode($webId)
        [string]$listId = [System.Web.HttpUtility]::UrlEncode($listId)
        [string]$userEmail = [System.Web.HttpUtility]::UrlEncode($userEmail)
        [string]$webUrl = [System.Web.HttpUtility]::UrlEncode($webUrl)
        #build the URI
        $uri = New-Object System.UriBuilder
        $uri.Scheme = "odopen"
        $uri.Host = "sync"
        $uri.Query = "siteId=$siteId&webId=$webId&listId=$listId&userEmail=$userEmail&webUrl=$webUrl&listTitle=$listTitle&webTitle=$webTitle"
        #launch the process from URI
        Write-Host $uri.ToString()
        start-process -filepath $($uri.ToString())
    }
    catch {
        $errorMsg = $_.Exception.Message
    }
    if ($errorMsg) {
        Write-Warning "Sync failed."
        Write-Warning $errorMsg
    }
    else {
        Write-Host "Sync completed."
        return $true
    }    
}
#endregion
#region Main Process
try {
    #region Sharepoint Sync
    [mailaddress]$userUpn = cmd /c "whoami/upn"
    $params = @{
        #replace with data captured from your sharepoint site.
        siteId    = "{ac510f85-7e51-41d8-87d0-9dd44cb557e8}"
        webId     = "{4a52b637-d2a0-4b9e-948c-65edbbb94756}"
        listId    = "{CBA78A76-ACD5-4DDB-88FA-C7022DDF906F}"
        userEmail = $userUpn
        webUrl    = "https://krclogistics.sharepoint.com/sites/Security"
        webTitle  = "Security"
        listTitle = "Documents"
    }
    $regKeyLocation="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $ScriptName="SharepointSync-Security"
    $params.syncPath  = "$(split-path $env:onedrive)\KRC Logistics\$($params.webTitle) - $($Params.listTitle)"
    Write-Host "SharePoint params:"
    $params | Format-Table
    if (!(Test-Path $($params.syncPath))) {
        Write-Host "Sharepoint folder not found locally, will now sync.." -ForegroundColor Yellow
        $sp = Sync-SharepointLocation @params
        if (!($sp)) {
            Throw "Sharepoint sync failed."
        }
    }
    else {
        Write-Host "Location already syncronized: $($params.syncPath)" -ForegroundColor Yellow
        Remove-ItemProperty -Path $regKeyLocation -Name $ScriptName -Force
    }
    #endregion
}
catch {
    $errorMsg = $_.Exception.Message
}
finally {
    if ($errorMsg) {
        Write-Warning $errorMsg
        Throw $errorMsg
    }
    else {
        Write-Host "Completed successfully.."
    }
}
#endregion