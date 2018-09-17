#!/usr/bin/env bash

set -eu
set -o pipefail

docker_tag=
login_args=()
build_args=()

function self::prepare() {
	
	while [[ ${#} -gt 0 ]]
	do
		case ${1} in
			
			-t)
				docker_tag=${2}
				shift
				;;
			
			--no-include-email)
				login_args+=(${1})
				;;
			
			*)
				build_args+=(${1})
				;;
		esac
		
		shift
	done
	
	local aws_region=$(echo ${docker_tag} | grep -oP '\.ecr\.\K([^\.]+)') || :
	
	if [[ -z ${aws_region} ]]; then
		
		echo 'Usage: '$(basename ${0})' -t [ecr-repository-uri]:[tag] ......' >&2
		
		exit 1
	fi
	
	login_args+=(--region)
	login_args+=(${aws_region})	
	
	build_args+=(-t)
	build_args+=(${docker_tag})
}

function self::execute() {
	
	$(aws ecr get-login ${login_args[@]})
	
	docker build ${build_args[@]}
	docker push ${docker_tag}
}

{
	self::prepare ${@}
	self::execute
}
