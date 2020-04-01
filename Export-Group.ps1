#Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#Input variables
$WebURL = "http://cgfs13index1dev/"

$Web = Get-SPWeb $WebURL
  
 #Get all Groups and Iterate through   
 foreach ($group in $Web.groups)
 {
    #Get Permission Levels Applied to the Group  
    $RoleAssignment = $Web.RoleAssignments.GetAssignmentByPrincipal($group)
 
    $RoleDefinitionNames=""
    foreach ($RoleDefinition in $RoleAssignment.RoleDefinitionBindings)
    { 
        $RoleDefinitionNames+=$RoleDefinition.Name+";"
    }
     
    write-host "Group Name: $($Group.name) : Permissions: $($RoleDefinitionNames) ----"
    #Iterate through Each User in the group
        foreach ($user in $group.users)
        {
            write-host $user.name  "`t" $user.LoginName  "`t"  $user.Email  | FT
        }
 } 


#Read more: https://www.sharepointdiary.com/2013/07/export-sharepoint-users-and-groups-to-excel-using-powershell.html#ixzz6IIijYh48