#!/bin/sh

set -eu

set DEBUG=*

echo "== npm install -g prisma =="
npm install -g prisma
echo ""
echo ""
echo "======================="
echo ""
echo ""
echo "== npm install -g @prisma/cli@alpha =="
npm install -g @prisma/cli@alpha
