function Write-ServerResult($tcpconns) {
    if (!$tcpconns) {
        return
    }
    $Unique_Addresses = $tcpconns | Sort-object -property RemoteAddress -unique
    write-host "Connections:"
    foreach ($address in $Unique_Addresses) {
        if ($is_good_ip.ContainsKey($address.RemoteAddress)) {
            if ($is_good_ip[$address.RemoteAddress]) {
                $Result = "GOOD"
            } else {
                $Result =  "BAD" 
            }
        }
        else{
            $Result = 'Unknown'
        }
        
        $Message = '{0} : ({1})' -f $address.remoteaddress,$Result
        Write-Host "$message"
    }
    write-host "`r"
}

Write-Host "Starting d3servercheck"

$csv = Import-Csv -Path servers.csv

try {
    $Diablo3_Process = get-process -name 'Diablo III64' -ErrorAction Stop
}
Catch{
    write-error "Diablo 3 is not running. Exiting script..."
    exit 1
}

$is_good_ip = @{}

foreach ($ip in $csv) {
    $is_good_ip.Add($ip.server, $ip.status -eq "good")
}

Write-Host "Read servers"
Write-Host "Starting checks"

while ($true) {
    Start-Sleep -s 5

    $Diablo3_ActiveConnections = get-NetTCPConnection -owningprocess $Diablo3_Process.id

    Write-ServerResult $Diablo3_ActiveConnections
}
