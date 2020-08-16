#!/bin/sh

set -e

TMP=$(mktemp)
trap "rm -f $TMP" exit

cp servers.csv $TMP
sort -t . -k3,3n -k 4,4n $TMP > servers.csv
