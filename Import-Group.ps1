
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue 

$TargetURL = "http://cgfs13index1dev/sites/GroupMigrateTest"
$TargetWeb = Get-SPWeb $TargetURL

$ownername = "GroupMigrateTest Owners"
$owner = $targetWeb.groups[$ownername]


$sourcegroups = Import-Csv .\groups.csv

foreach ($group in $sourcegroups) {
  # Write-Output $group.Name
  if ($TargetWeb.SiteGroups[$group.Name] -ne $null) { 
      write-Host $group.Name " Group exists Already!" -ForegroundColor Red
  } else {
    $TargetWeb.SiteGroups.add($group.Name, $owner, $TargetWeb.site.owner, $group.description)
  }


#Read more: https://www.sharepointdiary.com/2015/01/create-sharepoint-group-using-powershell.html#ixzz6INbhDxCV
 #$TargetWeb.SiteGroups.Add($group.Name, $owner, $null, $group.description)
 #$destinationGroup = $TargetWeb.SiteGroups["$group"]
 #$destinationGroup.owner = $owner
 #$destinationGroup.Update()
}

Write-Output "`n"

$usergroupmembers = Import-Csv ./groupmembers.csv

foreach ($user in $usergroupmembers) {
    Write-Output $user.LoginName
    $veruser = $TargetWeb.EnsureUser($user.LoginName)
    if ($veruser -ne $null) {

        $group = $TargetWeb.SiteGroups[$user.Group]
        #Write-Output $group
        $group.AddUser($veruser)
    }
   
}

$grouproles = Import-Csv ./grouproles.csv

foreach ($role in $grouproles) {
         Write-Output $role.Group
        $siteGroup = $TargetWeb.SiteGroups[$role.Group]  
        $roleAssignment = new-object Microsoft.SharePoint.SPRoleAssignment($sitegroup) 
        $roleDefinition = $web.Site.RootWeb.RoleDefinitions[$role.Name]  
        #Write-Output $roleDefinition
        $roleAssignment.RoleDefinitionBindings.Add($roleDefinition)
        $TargetWeb.RoleAssignments.Add($roleAssignment)  
        $TargetWeb.Update()
}