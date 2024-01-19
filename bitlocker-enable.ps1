# Load .env file content
import-Module (Join-Path (Get-Location) "load-envfile.psm1" )
Import-EnvFile

$COMPANY_NAME = [System.Environment]::GetEnvironmentVariable("COMPANY_NAME", [System.EnvironmentVariableTarget]::Process)
$HOSTNAMES_FILE = [System.Environment]::GetEnvironmentVariable("HOSTNAMES_FILE", [System.EnvironmentVariableTarget]::Process)
$ADMIN_USERNAME = [System.Environment]::GetEnvironmentVariable("ADMIN_USERNAME", [System.EnvironmentVariableTarget]::Process)

Write-Output "### $COMPANY_NAME - Batch Enable Microsoft BitLocker ###"

# Get current date and define output file path
$date = Get-Date -Format "yyyy-MM-dd"
$outputDir = Join-Path (Get-Item .).FullName "logs"
$logFilePath = Join-Path $outputDir "bitlocker-$date.log"
$offline = Join-Path $outputDir "bitlocker-$date-offline.log"
Write-Output "Output log file: $logFilePath"

# Import list of machines
$csvPath = Join-Path (Get-Item .).FullName "temp\$HOSTNAMES_FILE"
$computers = Import-CSV $csvPath | Select-Object -ExpandProperty Name
$credential = Get-Credential -Credential "$ADMIN_USERNAME"

# Define a logging function
function Log-Message {
    Param (
        [string]$Message,
        [string]$FilePath = $outputFilePath
    )
    Write-Host $Message
    Add-Content -Path $FilePath -Value "$(Get-Date -Format "HH:mm:ss"): $Message" -Encoding UTF8
}

foreach ($computerName in $computers) {
    Log-Message "=================================================" 
    Log-Message "Processing $computerName" 

    if (-not (Test-Connection -ComputerName $computerName -Count 1 -Quiet)) {
        Log-Message "$computerName is offline." 
        Log-Message "$computerName" $offline
        continue
    }

    Log-Message "$computerName is online." 

    # Script Block to enable BitLocker
    $scriptBlock = {
        try {
            $bitLockerStatus = Get-BitLockerVolume -MountPoint "C:"
            if ($bitLockerStatus.VolumeStatus -ne "FullyEncrypted") {
                Enable-BitLocker -MountPoint "C:" -UsedSpaceOnly -RecoveryPasswordProtector
                return Get-BitLockerVolume -MountPoint "C:"
            } else {
                return "BitLocker is already enabled on the drive."
            }
        } catch {
            return "Error enabling BitLocker: $($_.Exception.Message)"
        }
    }

    $result = Invoke-Command -ComputerName $computerName -Credential $credential -ScriptBlock $scriptBlock
    Log-Message "Result for ${computerName}: $result" 
}
