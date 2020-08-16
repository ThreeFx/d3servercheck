Write-Host "Starting d3servercheck"

$csv = Import-Csv -Path .\Documents\servers.csv

$hm = @{}

foreach ($ip in $csv) {
    $hm.Add($ip.server, $ip.status -eq "good")
}

$ips = $csv.server

Write-Host "Read servers"
Write-Host "Starting checks"

while (0 -lt 1) {
    Start-Sleep -s 5

    $tcpconns = Get-NetTCPConnection -RemoteAddress $ips -EA SilentlyContinue

    if (!$tcpconns) {
        Write-Host "no TCP connections to known servers found"
        continue;
    }

    $hasgood = 1 -lt 0
    $hasbad = 1 -lt 0
    $isunknown = $tcpconns.Length -eq 0

    foreach ($tcpconn in $tcpconns) {
        if ($hm[$tcpconn.RemoteAddress]) {
            $hasgood = 0 -lt 1
        } else {
            $hasbad = 0 -lt 1
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
