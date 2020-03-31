#!/bin/sh

set -eu

export DEBUG=*

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

echo ""
echo ""
echo "======================="
echo ""
echo ""
echo "== prisma -v =="
prisma -v
echo "== prisma2 -v =="
prisma2 -v
echo "== npx prisma -v =="
npx prisma -v
echo "== npx prisma2 -v =="
npx prisma2 -v