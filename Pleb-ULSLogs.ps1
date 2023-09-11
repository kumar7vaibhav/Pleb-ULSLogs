## Collect ULS logs in one go. 
## Thanks to Anthony for the main script. [https://github.com/acasilla]
##  


Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Function to fetch servers if required by customer.
function Get-SelectedServers {
    $serverDictionary = @{}
    $servers = Get-SPServer | Where-Object { $_.Role -ne "Invalid" } | Select Name, Role, Status

    $i = 1
    Write-Host "SharePoint Servers in the farm - "
    foreach ($server in $servers) {
        $serverDictionary.Add($i, $server.Name)
        Write-host "$($i). $($Server.Name) | Role: $($server.Role)"
        $i += 1
    }

    # Initialize an empty array to store the servers
    $inputServerList = @()

    # Prompt the user for input
    $userInput = Read-Host "Enter a list of servers separated by commas (e.g., 1, 2, 3):"

    # Split the user input by commas and trim any leading/trailing whitespace
    $formattedInputServ = $userInput -split ',' | ForEach-Object { $_.Trim() }

    # Iterate through the servers and add them to the list
    foreach ($server in $formattedInputServ) {
        # Use TryParse to ensure the input is a valid server
        if ([int]::TryParse($server, [ref]$null)) {
            # Match the index to the server name. and add it to a list.
            $inputServerList += $serverDictionary[[int]$server]
        } else {
            Write-Host "Invalid server: $server"
        }
    }

    # Initialize an empty array to store the formatted items
    $selectedServers = @()

    # Loop through each item in the list and format it as "item"
    foreach ($item in $inputServerList) {
        $formattedItem = '"' + $item + '"'
        $selectedServers += $formattedItem
    }

    # Check if list is null
    if ($selectedServers -eq $null) {
        $selectedServers = ""
    } else {
        $selectedServers = $selectedServers -join ", "
    }
    $selectedServers = Invoke-Expression $selectedServers
    Return $selectedServers
}

Invoke-WebRequest -Uri https://github.com/acasilla/CollectULSLogs/releases/download/v1.0/Get-ULSLogs.ps1 -OutFile "$env:TEMP\Get-ULSLogs.ps1"

#Part 1
Write-Host "Starting - Part 1 [VerboseEx, start marker]" -ForegroundColor Cyan
Set-SPLogLevel -TraceSeverity Verboseex
$starttime = Get-Date
Write-Host "Finished - Part 1"

Write-Host "Please recreate the error and collect correlation ID (if any)" -ForegroundColor Red
Write-Host "Press Enter when done..." 
$null = Read-Host

#Part 2 
Write-Host "Starting - Part 2 [End marker, Clear Log Level, Start main script]" -ForegroundColor Cyan
$endtime = Get-Date
Clear-SPLogLevel

cd $env:TEMP

$ServerChoice = Read-Host "Do you want logs from specific servers? (y/n)"

if ($ServerChoice -eq "Y" -or $ServerChoice -eq "y") {
    $ChosenServers = Get-SelectedServers
    .\Get-UlsLogs.ps1 -Servers $ChosenServers -startTime $starttime -endTime $endtime
}
elseif ($ServerChoice -eq "N" -or $ServerChoice -eq "n") {
    .\Get-UlsLogs.ps1 -startTime $starttime -endTime $endtime 
}
else {
    Write-Host "Invalid choice. Please enter 'Y' for Yes or 'N' for No."
}

$null = Read-Host "Enter to close - "
