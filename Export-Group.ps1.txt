$WebURL = "http://"

$Web = Get-SPWeb $WebURL

$web.Groups | Export-Csv -Path ./groups.csv

"Group,LoginName,StrippedLoginName" | Out-File "./usergroupmembers.csv" -append

 #Get all Groups and Iterate through   
 foreach ($group in $Web.groups)
 {
    # Dump all the groups/users into a csv file
        foreach ($user in $group.users)
        {
            Write-Output $user.LoginName
            $group.name + "," + $user.LoginName + "," + $user.LoginName.split("|")[1] | Out-File "./usergroupmembers.csv" -append
        }
 } 