#!/bin/sh

set -eux

c1="$1"
c2="$2"

set +x
echo "------------------------------"
echo ""
echo "command A: $c1"
echo "command B: $c2"
echo ""
echo "------------------------------"
set -x

set +e
$c1
code=$?
set -e

if [ $code -ne 0 ]; then
	set +x
	echo "------------------------------"
	echo ""
	echo "command A failed"
	echo "$c1"
	echo ""
	echo "------------------------------"
	exit 0
fi

set +e
$c2
code=$?
set -e

if [ $code -ne 0 ]; then
	set +x
	echo "------------------------------"
	echo ""
	echo "command B failed"
	echo "$c2"
	echo ""
	echo "------------------------------"
	exit 0
fi

set +x
echo ""
echo ""
echo "------------------------------"
echo ""
echo "results:"
echo ""

echo "prisma2 -v:     '$(prisma2 -v)'"
echo "npx prisma -v:  '$(npx prisma -v)'"
echo "npx prisma2 -v: '$(npx prisma2 -v)'"

echo ""
echo "------------------------------"
