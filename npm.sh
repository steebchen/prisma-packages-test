#!/bin/bash

set -eu

success="✅"
fail="❌"

p1="prisma"
old="prisma2@2.0.0-preview023"
mid="@prisma/cli@2.0.0-alpha.993"
latest="@prisma/cli@2.0.0-beta.1"

global="-g"
local=""

failed="______PROGRAM_FAILED______"

upgrade_error="has been renamed to"

## declare an array variable
pm="npm i"
declare -a scopes_from=("$global" "")
declare -a scopes_to=("$global" "")
declare -a from_versions=(
#	"$p1"
	"$old"
)
declare -a to_versions=(
#	"$mid"
	"$latest"
	#""
)

declare -a expectations=(
	"$global;$old;$global;$latest;$upgrade_error"
	"$global;$old;$local;$latest;$upgrade_error"
	"$local;$old;$global;$latest;$upgrade_error"
	"$local;$old;$local;$latest;$upgrade_error"
)

mkdir -p "logs/"

code=0

for scope_from in "${scopes_from[@]}"; do
	for scope_to in "${scopes_to[@]}"; do
		for from_version in "${from_versions[@]}"; do
			for to_version in "${to_versions[@]}"; do
				a="$pm $scope_from $from_version"
				b="$pm $scope_to $to_version"

				log=$(echo "$a --- $b.txt" | sed -e 's/ /_/g' | sed -e 's/\//∕/g')
				log="logs/$log"

				echo ""
				echo "from:   $a"
				echo "to:     $b"
				echo "logs:   $log"

				docker run -it --entrypoint bash node -c "$a > /dev/null && ($b || echo '$failed')" > "$log"
				out=$(cat "$log")

				has_expectation="false"
				for exp in "${expectations[@]}"; do
					IFS=";"
					arr=($exp)
					IFS=" "

					# TODO check for duplicate expectation, happens sometimes

					expect_from_scope="${arr[0]}"
					expect_from_version="${arr[1]}"
					expect_to_scope="${arr[2]}"
					expect_to_version="${arr[3]}"
					expect_str="${arr[4]}"

					if [[ "$expect_from_scope" = "$scope_from" ]] &&
						[[ "$expect_from_version" = "$from_version" ]] &&
						[[ "$expect_to_scope" = "$scope_to" ]] &&
						[[ "$expect_to_version" = "$to_version" ]]
					then
						has_expectation="true"
						if [[ "$out" == *"$expect_str"* ]]; then
#							echo "has:    $expect_str"
							echo "status: $success"
						else
#							echo "has:    $expect_str"
							echo "status: $fail"
							code=1
						fi
					fi
				done

				if [[ "$has_expectation" = "false" ]]; then
					echo "(no expectation)"
				fi

				echo ""
				echo "-----"
			done
		done
	done
done

exit $code
