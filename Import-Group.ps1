#Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#Input variables
#$SourceWebURL = "http://cgfsaudit.cgfsdc.state.sbu/sites/finaudit"
$TargetWebURL = "http://auditst.cgfsdc.state.sbu/sites/finaudit"
#In my scenario I will add a SharePoint group as the groups owner but you choose to use a user instead, make sure the user or group is available
#in the destination site collection
$ownername = "CGFS Fin Audit Tracking Tool Owners"
#below define your string on which you filter for the groups to copy. You can choose to copy all groups or create your own filtering. 
#I filtered for groups which match a certain string. Change this based on your needs.
#$yourstring = "*something*"
#Get the Webs
#$SourceWeb = Get-SPsite $SourceWebURL
$TargetWeb= Get-SPWeb $TargetWebURL
#$owner = $targetWeb.groups[$ownername]
#Get the Source groups
#$SourceGroup = $SourceWeb.rootweb.sitegroups #| where {$_.name -like ($yourstring) }
#$SourceGroup | Export-Csv -Path .\groups.csv

$SourceGroup = Import-CsV -Path .\groups.csv

foreach ($group in $SourceGroup)
{
 $TargetWeb.SiteGroups.Add($group.Name, $owner, $null, $group.description)
 $destinationGroup = $TargetWeb.SiteGroups["$Group"]
 $destinationGroup.owner = $owner
 $destinationGroup.Update()
 $groupUsers = Import-Csv -Path .\groupUsers\ + $group.Name.ToString() + .csv
 foreach ($user in $groupUsers){$TargetWeb.SiteGroups["$Group"].AddUser($user)}
 $destinationGroup.Update()
}