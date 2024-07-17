$groups = @("GroupName1", "GroupName2", "GroupName3")

foreach ($group in $groups) {
    Get-ADGroupMember -Identity $group | Get-ADUser -Properties * | Select-Object Name,SamAccountName,UserPrincipalName | Export-Csv -Path "$group-Members.csv" -NoTypeInformation
}
