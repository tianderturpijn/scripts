Import-Module ActiveDirectory

#https://www.powershellgallery.com/packages/OMSIngestionAPI/1.6.0
Import-Module OMSIngestionAPI -verbose
$workspaceID = "yourWorkpaceId"
$workspaceKey = "yourWorkspacekey"

#region Ingest User information
$ADusersTable = @()
$ADusers = Get-ADUser -Filter * -Properties * | ForEach-Object {
    $ADusersTable += [pscustomobject]@{
        DisplayName = $_.DisplayName
        GivenName = $_.GivenName
        LastName = $_.sn
        UserPrincipalName = $_.UserPrincipalName
        Enabled = $_.Enabled
        DistinguishedName = $_.DistinguishedName
        SamAccountName = $_.SamAccountName
        SID = $_.SID
        Mail = $_.mail
        MemberOf = $_.MemberOf
        ObjectGUID = $_.ObjectGuid
        Office = $_.Office
        LastLogon = $_.lastLogon
        LastlogonDate = $_.LastlogonDate
        PasswordLastSet = $_.PasswordLastSet
        GroupMemberOf = $_.MemberOf

    }
}

$ADusersJson = ConvertTo-Json -InputObject $ADusersTable
$TimeStampField = Get-Date -Format o
$LogType = 'adds_users'

Send-OMSAPIIngestionFile -customerId $workspaceID -sharedKey $workspaceKey -body $ADusersJson -logType $LogType -TimeStampField $TimeStampField
#endregion

#region import AD groups
$ADgroupsTable = @()
$ADgroups = Get-ADGroup -Filter * -Properties * | ForEach-Object {
    $ADgroupsTable += [PSCustomObject]@{
        Name = $_.Name
        DistinguishedName = $_.DistinguishedName
        GroupCategory = $_.GroupCategory
        GroupScope = $_.GroupScope
        Members = $_.Members
        CreateTimeStamp = $_.CreateTimeStamp
        ModifyTimeStamp = $_.modifyTimeStamp
    }
}
$ADgroupJson = ConvertTo-Json -InputObject $ADgroupsTable
$TimeStampField = Get-Date -Format o
$LogType = 'adds_groups'
Send-OMSAPIIngestionFile -customerId $workspaceID -sharedKey $workspaceKey -body $ADgroupJson -logType $LogType -TimeStampField $TimeStampField

#endregion
