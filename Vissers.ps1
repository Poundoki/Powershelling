Param ([Parameter(Mandatory=$true)][string]$CsvLocatie)New-ADOrganizationalUnit -Name "Vissers" -Path "DC=wayne,DC=intra" -ProtectedFromAccidentalDeletion:$false -Server:“dc-02"New-ADGroup -Name "G_everyone" -Path "OU=Vissers,DC=wayne,DC=intra" -GroupScope Global$csv = Import-Csv $CsvLocatie -Delimiter ";"$csv | ForEach-Object { $_.Department } | Select-Object -Unique {New-ADOrganizationalUnit -Name $_ -Path "OU=Vissers,DC=wayne,DC=intra" -ProtectedFromAccidentalDeletion:$false -Server:“dc-02"New-ADGroup -Name G_$($_) -Path "OU=$($_),OU=Vissers,DC=wayne,DC=intra" -GroupScope Global}


foreach ($user in $Csv) {
New-ADUser -Name $user.name -Surname $user.surname -SamAccountName $user.samaccountname -GivenName $user.givenname -Title $user.title -Department $user.department -Company $user.company -UserPrincipalName $user.userprincipalname -EmailAddress $user.mail -Path $user.path -AccountPassword (ConvertTo-SecureString -AsPlainText "Hotel123" -force) -enabled:$true
Add-ADGroupMember G_$($user.department) $user.samaccountname
Add-ADGroupMember G_everyone $user.samaccountname}

