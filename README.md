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

Note: This may be a high risk if you are prone to fishing/social engineering
attacks. **Do this at your own risk!**

## Running the program

Download a ZIP archive of this repository (top-right of the file listings),
unpack and then right-click `d3servercheck.ps1` and then `Run PowerShell
script`. If you cannot run this script check if you did the previous step
correctly.

You do not have to start Diablo 3 before starting this program, it will
automatically pick up on the game's connections. When running successfully
you should see output like this:

```
Starting d3servercheck
Read servers
Starting checks
no TCP connections to known servers found       <-- You are either not connected to the Blizzard
no TCP connections to known servers found           servers yet, or you are connected to a server
no TCP connections to known servers found           of unknown status
no TCP connections to known servers found
connected to GOOD server                        <-- You are connected to a known good server
connected to GOOD server
connected to GOOD server
connected to BAD server                         <-- You are connected to a known bad server
connected to BAD server
connected to BAD serve
connected to GOOD BAD server                    <-- You have been connected to both a known good
connected to GOOD BAD server                        and known bad server. Wait a few seconds for the old
connected to GOOD BAD server                        connections to close
```

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

## License

This work is licensed under the GNU GPLv3.

## FAQ

### What about support for MacOS?

The current script works only for Windows. I don't have a Mac or a BSD-device to
test on and I also have exams next week, so I won't be able to support Macs in
the near future. Hopefully I won't need to and the bug will be fixed soon. If
not pull requests are welcome!

### Disclaimer

Diablo is a trademark or registered trademark of Blizzard Entertainment, Inc., in the U.S. and/or other countries.
