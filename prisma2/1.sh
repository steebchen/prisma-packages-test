#!/bin/sh

set -eu

set DEBUG=*

echo "== npm install -g prisma2 =="
npm install -g prisma2
echo ""
echo ""
echo "======================="
echo ""
echo ""
echo "== npm install -g @prisma/cli@alpha =="
npm install -g @prisma/cli@alpha