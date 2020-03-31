#!/bin/sh

set -eu

export DEBUG=*

npm config get
npm list depth 0 || true
npm list -g depth 0 || true
npm init -y
npm install @prisma/cli@2.0.0-alpha.993

command1="npm install -g prisma"
command2="npx @prisma/cli@2.0.0-alpha.993"

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
#echo "== prisma2 -v =="
#prisma2 -v
echo "== npx prisma -v =="
npx prisma -v
echo "== npx prisma2 -v =="
npx prisma2 -v