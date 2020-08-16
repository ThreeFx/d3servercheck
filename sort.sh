#!/bin/sh

set -e

sort -t . -k3,3n -k 4,4n servers.csv -o servers.csv
