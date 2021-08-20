### Query samples

adds_users_CL
| where PasswordLastSet_t between (datetime(2021-08-12 12:00:00) .. datetime(now))
| project PasswordLastSet_t

adds_groups_CL
| where parse_json(Members_s)[0] has "AzureDefender"

//looking for group changes and join this with the user table
SecurityEvent
| where Computer == "yourDomainController"
| where EventID == 4729
| extend userName = MemberName
| join kind=inner (
adds_users_CL
| extend userName = DistinguishedName_s
) on userName
