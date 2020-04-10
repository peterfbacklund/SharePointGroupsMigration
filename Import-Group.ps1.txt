$TargetURL = ""
$TargetWeb = Get-SPWeb $TargetURL

$ownername = "Financial Audit Site Owners"
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