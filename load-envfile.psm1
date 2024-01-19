function Import-EnvFile {
    param (
        [string]$Path = (Join-Path (Get-Location) ".env")
    )

    # Check if the .env file exists
    if (-Not (Test-Path $Path)) {
        throw "Error: .env file not found at $Path."
    }

    # Read the content of the .env file
    $content = Get-Content $Path

    # Check if the file is empty
    if (-Not $content) {
        throw "Error: .env file is empty."
    }

    # Parse each line of the .env file and set environment variables
    foreach ($line in $content) {
        if ($line -like "*=*") {
            $keyValue = $line -split '=', 2
            $key = $keyValue[0].Trim()
            $value = $keyValue[1].Trim()
            [System.Environment]::SetEnvironmentVariable($key, $value, [System.EnvironmentVariableTarget]::Process)
        } else {
            Write-Host "Warning: Ignoring line with unrecognized format or comment: $line"
        }
    }
}
