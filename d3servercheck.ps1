function Write-Server-Result($tcpconns) {
    if (!$tcpconns) {
        return
    }

    foreach ($tcpconn in $tcpconns) {
        Write-Host "$($tcpconn.RemoteAddress) (" -NoNewline
        if ($is_good_ip.ContainsKey($tcpconn.RemoteAddress)) {
            if ($is_good_ip[$tcpconn.RemoteAddress]) {
                Write-Host "GOOD" -NoNewline
            } else {
                Write-Host "BAD" -NoNewline
            }
        } else {
            Write-Host "UNKNOWN" -NoNewline
        }

        Write-Host ") " -NoNewline
    }
}

Write-Host "Starting d3servercheck"

$csv = Import-Csv -Path servers.csv

$is_good_ip = @{}

foreach ($ip in $csv) {
    $is_good_ip.Add($ip.server, $ip.status -eq "good")
}

$blizzard_server_ips_32 = @()
$blizzard_server_ips_33 = @()
$known_ips = $csv.server
for ($j=0; $j -lt 256; $j++) {
    $ip_32 = "37.244.32.$($j)"
    $ip_33 = "37.244.33.$($j)"
    if (!$is_good_ip.ContainsKey($ip_32)) {
        $blizzard_server_ips_32 += $ip_32
    }

    if (!$is_good_ip.ContainsKey($ip_33)) {
        $blizzard_server_ips_33 += $ip_33
    }
   
}

Write-Host "Read servers"
Write-Host "Starting checks"

while ($true) {
    Start-Sleep -s 5

    $tcpconns_0 = Get-NetTCPConnection -RemoteAddress $known_ips -EA SilentlyContinue
    $tcpconns_1 = Get-NetTCPConnection -RemoteAddress $blizzard_server_ips_32 -EA SilentlyContinue
    $tcpconns_2 = Get-NetTCPConnection -RemoteAddress $blizzard_server_ips_33 -EA SilentlyContinue

    if (!$tcpconns_0 -and !$tcpconns_1 -and !$tcpconns_2) {
        Write-Host "no connection to Blizzard game servers detected"
        continue;
    }

    Write-Host "connections: " -NoNewline

    Write-Server-Result($tcpconns_0)
    Write-Server-Result($tcpconns_1)
    Write-Server-Result($tcpconns_2)

    Write-Host ""
}
