<#
    .Synopsis
        Check Administrators group in a remote machine and set default members
    .Description
        Check Administrators group in a remote machine and set default members
    .Example
        powershell localgroup-check.ps1 DESKTOP07
#>

Write-Host -ForegroundColor Green "*** LOCALGROUP ADMINISTRATORS CHECK APP ***"

if ($args.Count -eq 0) {
    Write-Host "Missing argument"
    Write-Host "You need to add remote machine hostname"
    continue
}

$remote_host = $args[0]

[System.Collections.ArrayList]$admin_members_approved = "HelpDesk", "Domain Admins"

# check if machine is online
Write-Host Checking host -NoNewline
Write-Host -ForegroundColor Green " $remote_host"
if ( (Test-Connection -BufferSize 32 -Count 1 -ComputerName $remote_host -Quiet) -eq $false ) {
    Write-Host -ForegroundColor White -BackgroundColor Red [ERROR] -NoNewline
    Write-Host " $remote_host if offline, make sure that remote host is online and try again"
    Write-Host $args[1] 
    if($args[1] -eq $false) {
        continue    
    }
}


# Get Remote Administrators group members
$remote_group_members = ''
try {    
    $remote_group_members = Invoke-Command -ComputerName $remote_host -ErrorAction Stop { Get-LocalGroupMember -Group "Administrators" } | Select-Object 'Name'
}
catch {
    Write-Host -ForegroundColor White -BackgroundColor Red [CRITICAL ERROR] -NoNewline
    Write-Host " Impossible to execute powershell command in the remote machine, check if you have powershell avaible"
    continue
}

[System.Collections.ArrayList]$t = @()
foreach($member in $admin_members_approved) {
    $null = $t.Add($member.toUpper())
}
$admin_members_approved = $t.Clone()

# Process information
Write-Host -ForegroundColor Green Processing...
[System.Collections.ArrayList]$admin_members_approved_to_add = $admin_members_approved.Clone()
[System.Collections.ArrayList]$not_allowed_users = @()
foreach ($remote_member in $remote_group_members) {
    $member = $remote_member.Name
    $member = $member.Split('\')[1]
    $member = [regex]::Escape($member)
    $member = $member.Replace('\\', '\' )
    $member = $member.Replace('\ ', ' ')
    $member = $member.Replace('\', '')
    $member = $member.Trim()
    $member = $member.toUpper()
    if ($admin_members_approved -match $member) {
        Write-Progress -Activity "Processing $member"
        $null = $admin_members_approved_to_add.Remove($member)
        Start-Sleep -Milliseconds 200
    }
    else {
        Write-Host -ForegroundColor red $member not allowed!
        $null = $not_allowed_users.Add($member)
    }
}

Write-Host ""

# Add allowed members that is not in remote group
if($admin_members_approved_to_add.Count -gt 0) {   
    Write-Host -ForegroundColor Green "Starting ADD missing members..."
    foreach ($member in $admin_members_approved_to_add) {
        Write-Host Adding $member ...
        Invoke-Command -ComputerName $remote_host -ArgumentList $member { Add-LocalGroupMember -Group "Administrators" -Member $args[0] }
    }
}
else {
    Write-Host -ForegroundColor Green No missing membe!
}


# Delete not allowed members if found 
if($not_allowed_users.Count -gt 0) {   
    Write-Host ""
    Write-Host -ForegroundColor Gree "Starting Cleaning..."

    foreach ($notallowed in $not_allowed_users) {
        Write-Host -ForegroundColor Red Removing $notallowed ...
        
        Invoke-Command -ComputerName $remote_host -ArgumentList $notallowed { Remove-LocalGroupMember -Group "Administrators" -Member $args[0] }
    }
}
else {
    Write-Host -ForegroundColor Green $remote_host ok!
}









