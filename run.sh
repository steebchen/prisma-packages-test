#!/bin/sh

set -eux

c1="$1"
c2="$2"

export DEBUG="*"

set +e
$c1
code=$?
set -e

if [ $code -ne 0 ]; then
	set +x
	echo "------------------------------"
	echo ""
	echo "command A succeeded"
	echo "$c1"
	echo ""
	echo "------------------------------"
	set -x
fi

set +e
$c2
code=$?
set -e

if [ $code -ne 0 ]; then
	set +x
	echo "------------------------------"
	echo ""
	echo "command B succeeded"
	echo "$c2"
	echo ""
	echo "------------------------------"
	set -x
fi

set +x
echo ""
echo "------------------------------"
echo ""
echo "results:"
echo ""

echo "=== prisma2 -v ==="
prisma2 -v || true
echo "=== npx prisma -v ==="
npx prisma -v || true
echo "=== npx prisma2 -v ==="
npx prisma2 -v || true
