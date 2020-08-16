# d3servercheck

Program to check if your D3 is connected to a known good/bad server.

There was a bug in D3 Season 21 which meant that some servers did not submit
player's clears to the D3 Leaderboards. This script polls your D3 connections
and tells you whether you are connected to a known GOOD or BAD server.

## Enable PowerShell execution

In order to run this script you have to allow local PowerShell scripts to run.
To do this: Open a PowerShell as Administrator and then enter:

    C:> Set-ExecutionPolicy remotesigned
    
When prompted if you want to change the policy, enter `Y` and press enter.

## Running the program

Download a ZIP archive of this repository (top-right of the file listings),
unpack and then right-click `d3servercheck.ps1` and then `Run PowerShell script`.
If you cannot run this script check if you did the previous step correctly.
