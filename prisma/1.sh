#!/bin/sh

set -eu

set DEBUG=*

npm init -y

command1="npm install -g prisma"
command2="npm install -g @prisma/cli@alpha"

echo "== $command1 =="
$command1
echo ""
echo ""
echo "======================="
echo ""
echo ""
echo "== $command2 =="
$command2
