#!/usr/bin/env bash

set -eu
set -o pipefail

COMMAND_URL=https://github.com/spt-oss/spt-ci/raw/master/command

AWS_COMMANDS=( \
	ecr-upload \
	ecs-deploy \
)

GIT_COMMANDS=( \
	git-config-user \
	git-flow-release-finish \
	git-push-all \
)

MVN_COMMANDS=( \
	mvn-deploy \
	mvn-go-offline \
	mvn-license-format \
	mvn-release-perform \
	mvn-release-prepare \
	mvn-release \
	mvn-repackage \
	mvn-settings \
	mvn-test \
)

function self::install() {
	
	local group=${1:-aws,git,mvn}
	local commands=()
	
	if [[ ${group} =~ aws ]]; then
		
		commands=(${AWS_COMMANDS[@]});
	fi
	
	if [[ ${group} =~ git ]]; then
		
		commands=(${commands[@]} ${GIT_COMMANDS[@]});
	fi
	
	if [[ ${group} =~ mvn ]]; then
		
		commands=(${commands[@]} ${MVN_COMMANDS[@]});
	fi
	
	for name in ${commands[@]}; do
		
		echo 'Install: '${name}
		
		curl -fsSL ${COMMAND_URL}/${name}.sh -o ${name}.sh~
		
		chmod +x ${name}.sh~
		sudo mv ${name}.sh~ /usr/local/bin/${name}
	done
}

{
	pushd /tmp/ > /dev/null
	
	self::install ${@}
	
	popd > /dev/null
}
