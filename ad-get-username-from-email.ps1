
$input_file = Import-CSV ".\list.csv" | Select-Object EMAIL

$export_file = '.\list-result.csv'

foreach ($register in $input_file) 
{
    $email = $register.EMAIL
    Write-Progress -Activity "Processing $email" 
    Get-ADUser -Filter "EmailAddress -eq '$email'" -Properties DistinguishedName,Name,DisplayName,EmailAddress | Select-Object DisplayName, SamAccountName,EmailAddress | Export-CSV -Append -Path $export_file -NoTypeInformatio 
} 

Write-host ''
Write-Host "Data exported to file $export_file"
