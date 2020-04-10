Remove-Item -path .\groups.csv
Remove-Item -path .\groupmembers.csv
Remove-Item -path .\grouproles.csv

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#Input variables
$WebURL = "http://cgfs13index1dev/"

$Web = Get-SPWeb $WebURL

$web.Groups | Export-Csv -Path ./groups.csv

"Group,LoginName,StrippedLoginName" | Out-File "./groupmembers.csv" -append

"Group,Name" | Out-File "./grouproles.csv" -append

 #Get all Groups and Iterate through   
 foreach ($group in $Web.groups)
 {
    # Dump all the groups/users into a csv file
        foreach ($user in $group.users)
        {
            Write-Output $user.LoginName 
            $group.name + "," + $user.LoginName + "," + $user.LoginName.split("|")[1] | Out-File "./groupmembers.csv" -append
        }

        # Dump all the roles/permissions into a csv file
        foreach ($role in $group.Roles)
        {
            #Write-Output $role.xml | FT
            $group.name + "," + $role.Name | Out-File "./grouproles.csv" -append
        }
} 

#if ([Microsoft.SharePoint.Publishing.PublishingWeb]::IsPublishingWeb($web)) {
Get-spweb $web.Url | Get-PublishingPages | Export-Csv -Path ./pagemembers.csv
#}