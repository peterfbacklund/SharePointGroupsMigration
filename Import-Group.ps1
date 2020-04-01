$TargetURL = ""
$TargetWeb = Get-SPWeb $TargetURL

$ownername = "Fin Audit Owners"
$owner = $targetWeb.groups[$ownername]


$sourcegroups = Import-Csv .\groups.csv

foreach ($group in $sourcegroups) {
  # Write-Output $group.Name
  if ($TargetWeb.SiteGroups[$group.Name] -ne $null) { 
      write-Host $group.Name " Group exists Already!" -ForegroundColor Red
  } else {
    $TargetWeb.SiteGroups.add($group.Name, $owner, $TargetWeb.site.owner, $group.description)
  }
}


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
