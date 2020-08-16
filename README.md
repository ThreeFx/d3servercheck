# d3servercheck

Program to check if your D3 is connected to a known good/bad server.

There was a [bug in D3 Season 21 (at least on EU) which meant that some servers did not submit
player's clears to the D3
leaderboards](https://eu.forums.blizzard.com/en/d3/t/gr-150-cleared-but-not-recorded-04082020/2170/143).
This script polls your D3 connections and tells you whether you are connected to
a known GOOD or BAD server.

## Enable PowerShell execution

In order to run this script you have to allow local PowerShell scripts to run.
To do this: Open a PowerShell as Administrator and then enter:

    C:> Set-ExecutionPolicy remotesigned
    
When prompted if you want to change the policy, enter `Y` and press enter.

## Running the program

Download a ZIP archive of this repository (top-right of the file listings),
unpack and then right-click `d3servercheck.ps1` and then `Run PowerShell
script`.  If you cannot run this script check if you did the previous step
correctly.

## Adding servers

You can add servers by adding their IP and the fact whether they are good or bad to
[`servers.csv`](https://github.com/ThreeFx/d3servercheck/tree/master/servers.csv). The
file is in CSV format, meaning "comma-separated values". To append a new server
simply add

```
<YOUR_SERVER_IP>,good
```

if the server is good, or

```
<YOUR_SERVER_IP>,bad
```

if it is bad.

## Contributing

Pull requests and issues are welcome! If you have a problem and/or want to add
additional servers to the list please [open an
issue](https://github.com/ThreeFx/d3servercheck/issues), or submit a pull
request directly.
