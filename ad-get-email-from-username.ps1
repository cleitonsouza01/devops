
$input_file = Import-CSV ".\list.csv" | Select-Object user

$export_file = '.\test-result.csv' 

foreach ($user in $input_file)
{
    Write-Progress -Activity "Processing $user.user" 
    Get-ADUser $user.user -Properties * | Select-Object DisplayName, SamAccountName, EmailAddress | Export-CSV -Append -Path $export_file -NoTypeInformatio
}

Write-host ''
Write-Host "Data exported to file $export_file"