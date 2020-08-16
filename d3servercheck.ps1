Write-Host "Starting d3servercheck"

$csv = Import-Csv -Path servers.csv

$hm = @{}

foreach ($ip in $csv) {
    $hm.Add($ip.server, $ip.status -eq "good")
}

$ips = $csv.server

Write-Host "Read servers"
Write-Host "Starting checks"

while ($true) {
    Start-Sleep -s 5

    $tcpconns = Get-NetTCPConnection -RemoteAddress $ips -EA SilentlyContinue

    if (!$tcpconns) {
        Write-Host "no TCP connections to known servers found"
        continue;
    }

    $hasgood = $false
    $hasbad = $false
    $isunknown = $tcpconns.Length -eq 0

    foreach ($tcpconn in $tcpconns) {
        if ($hm[$tcpconn.RemoteAddress]) {
            $hasgood = $true
        } else {
            $hasbad = $true
        }
    }

    Write-Host "connected to " -NoNewline

    if ($isunknown) {
        Write-Host "UNKNOWN " -NoNewline
    } else {
        if ($hasgood) {
            Write-Host "GOOD " -NoNewline
        }
        
        if ($hasbad) {
            Write-Host "BAD " -NoNewline
        }
    }

    Write-Host "server"
}
