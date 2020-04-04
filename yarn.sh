#!/bin/bash

set -eu

node_version="13"
docker_image="node:$node_version"

echo "node version: $node_version"

success_emoji="✅"
fail_emoji="❌"

p1="prisma"
old="prisma2@2.0.0-preview023"
mid="@prisma/cli@2.0.0-alpha.993"
latest="@prisma/cli@2.0.0-beta.1"

v_npx_local="npx prisma2"
v_global="prisma2"

global="global"
local=""

exit_success=0
exit_fail=-1

upgrade_error="has been renamed to"

## declare an array variable
pm="yarn"
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
	"$global;$old;$global;$latest;$exit_fail;$upgrade_error;$v_global;$latest"
	"$global;$old;$local;$latest;$exit_success;-;$v_npx_local;$latest"
	"$local;$old;$global;$latest;$exit_success;-;$v_global;$latest"
	"$local;$old;$local;$latest;$exit_success;-;$v_npx_local;$latest"
)

mkdir -p "logs/"

code=0

for scope_from in "${scopes_from[@]}"; do
	for scope_to in "${scopes_to[@]}"; do
		for from_version in "${from_versions[@]}"; do
			for to_version in "${to_versions[@]}"; do
				a="$pm $scope_from add $from_version"
				b="$pm $scope_to add $to_version"

				log=$(echo "$a --- $b.txt" | sed -e 's/ /_/g' | sed -e 's/\//∕/g')
				log="logs/$log"

				echo ""
				echo "from:   $a"
				echo "to:     $b"
				echo "logs:   $log"

				# cutting -d : -f 2 and -d , -f 1 will successfully parse old and new outputs of prisma2 -v
				version_cmd="
					(echo 'prisma -v' && prisma -v | grep "^@prisma/cli" | cut -d : -f 2 | cut -d , -f 1 | xargs | tee /out/prisma.txt);
					(echo 'prisma2 -v' && prisma2 -v | grep "^@prisma/cli" | cut -d : -f 2 | cut -d , -f 1 | xargs | tee /out/prisma2.txt);
					(echo 'npx prisma -v' && npx prisma -v | grep "^@prisma/cli" | cut -d : -f 2 | cut -d , -f 1 | xargs | tee /out/npx_prisma.txt);
					(echo 'npx prisma2 -v' && npx prisma2 -v | grep "^@prisma/cli" | cut -d : -f 2 | cut -d , -f 1 | xargs | tee /out/npx_prisma2.txt);
				"

				set +e
				docker run -it -v "$(pwd)/out/:/out" --entrypoint bash "$docker_image" -c "mkdir -p /app && cd /app && node -v && npm -v && npm init --yes && $a > /dev/null && $b && $version_cmd" > "$log"
				code=$?
				set -e
				out=$(cat "$log")

				echo "code:   $code"

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
					expect_exit="${arr[4]}"
					expect_str="${arr[5]}"
					expect_cmd="${arr[6]}"
					expect_cmd_version="${arr[7]}"

					if [[ "$expect_from_scope" = "$scope_from" ]] &&
						[[ "$expect_from_version" = "$from_version" ]] &&
						[[ "$expect_to_scope" = "$scope_to" ]] &&
						[[ "$expect_to_version" = "$to_version" ]]
					then
						has_expectation="true"

						if ([[ "$expect_exit" == "$exit_success" ]] && [[ "$expect_exit" == "$code" ]]) ||
							([[ "$expect_exit" == "$exit_fail" ]] && [[ "$expect_exit" != "$code" ]]); then
							echo "exit:   $success_emoji"

							if [[ "$out" == *"$expect_str"* ]]; then
								echo "status: $success_emoji"
							else
								echo "status: $fail_emoji"
								code=1
							fi
						else
							echo "exit:   $fail_emoji"
							code=1
						fi

						if [[ "$expect_cmd" != "-" ]]; then
							actual_version="@prisma/cli@$(cat "./out/$(echo "$expect_cmd" | sed -e 's/ /_/g').txt")"
							echo "actual version: $actual_version"
							if [[ "$expect_cmd_version" != "$actual_version" ]]; then
								echo "version:   $expect_cmd_version != $actual_version $fail_emoji"
								code=1
							else
								echo "version: $success_emoji"
							fi
						else
							echo "version: n/a"
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
