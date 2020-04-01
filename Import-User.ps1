$TargetURL = ""
$TargetWeb = Get-SPWeb $TargetURL

$usergroupmembers = Import-Csv ./usergroupmembers.csv

foreach ($user in $usergroupmembers) {
    Write-Output $user.LoginName
    $veruser = $TargetWeb.EnsureUser($user.LoginName)
    if ($veruser -ne $null) {

        $group = $TargetWeb.SiteGroups[$user.Group]
        #Write-Output $group
        $group.AddUser($veruser)
    }
   
}