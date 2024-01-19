# Define the path to your .env file
$currentPath = Get-Location
$envFilePath = "$currentPath\.env"

# Check if the .env file exists
if (-Not (Test-Path $envFilePath)) {
    Write-Host "Error: .env file not found at $envFilePath."
    exit
}

# Read the content of the .env file
$content = Get-Content $envFilePath

# Check if the file is empty
if ($content.Length -eq 0) {
    Write-Host "Error: .env file is empty."
    exit
}

# Create a hashtable to store the key-value pairs
$envVars = @{}

# Parse each line of the .env file
foreach ($line in $content) {
    # Check if the line contains '=' character
    if ($line -like "*=*") {
        # Split the line into key and value at the '=' character
        $keyValue = $line -split '=', 2
        # Trim spaces and add the key-value pair to the hashtable
        $envVars[$keyValue[0].Trim()] = $keyValue[1].Trim()
    } else {
        Write-Host "Warning: Unrecognized format or comment in line: $line"
    }
}

# Check if any key-value pairs were added
if ($envVars.Count -eq 0) {
    Write-Host "Error: No valid key-value pairs found in .env file."
    exit
}

# Now you can access the values using the keys
# Example, to get the value of 'DATABASE_URL'
# $databaseUrl = $envVars["DATABASE_URL"]
# if ($null -eq $databaseUrl) {
#     Write-Host "Warning: DATABASE_URL not found in .env file."
# } else {
#     Write-Host "DATABASE_URL is $databaseUrl"
# }

# Assuming $envVars is your hashtable containing the key-value pairs from the .env file
Write-Host  "Environment variables found in $envFilePath"
foreach ($key in $envVars.Keys) {
    $value = $envVars[$key]
    Write-Host "$key = $value"
}
