#!/bin/sh

set -eu

set DEBUG=*

npm init -y
npm install @prisma/cli@alpha

command1="npm install -g prisma"
command2="npx @prisma/cli@alpha"

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
echo "== prisma -v =="
npx prisma -v
echo "== prisma2 -v =="
npx prisma2 -v