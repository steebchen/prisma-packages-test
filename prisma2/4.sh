#!/bin/sh

set -eu

set DEBUG=*

npm init -y
npm install @prisma/cli@alpha

command1="npm install -g prisma2@2.0.0-preview023"
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
prisma2 -v