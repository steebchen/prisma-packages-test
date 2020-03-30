#!/bin/sh

set -eu

set DEBUG=*

npm init -y

command1="npm install -g prisma2@2.0.0-preview023"
command2="npm install @prisma/cli@alpha"

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
echo "== prisma2 -v =="
prisma2 -v
echo "== prisma -v =="
npx prisma -v
echo "== prisma2 -v =="
npx prisma2 -v
