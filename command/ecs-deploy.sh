#!/usr/bin/env bash

set -eu
set -o pipefail

docker_image=
aws_region=
arguments=()

function self::prepare() {
	
	while [[ ${#} -gt 0 ]]
	do
		case ${1} in
			
			-i)
				docker_image=${2}
				shift
				;;
			
			-r)
				aws_region=${2}
				shift
				;;
			
			*)
				arguments+=(${1})
				;;
		esac
		
		shift
	done
	
	if [[ -z ${docker_image} ]]; then
		
		echo 'Usage: '$(basename ${0})' -i [docker-image] ......' >&2
		
		exit 1
	fi
	
	if [[ -z ${aws_region} ]]; then
		
		aws_region=$(echo ${docker_image} | grep -oP '\.ecr\.\K([^\.]+)') || :
	fi
	
	if [[ -z ${aws_region} ]]; then
		
		echo 'Usage: '$(basename ${0})' -r [aws-region] ......' >&2
		
		exit 1
	fi
	
	arguments+=(-i)
	arguments+=(${docker_image})
	arguments+=(-r)
	arguments+=(${aws_region})
}

function self::execute() {
	
	local delegate=/tmp/ecs-deploy.sh~
	
	if [ ! -f ${delegate} ]; then
		
		curl -fsSL https://github.com/silinternational/ecs-deploy/raw/master/ecs-deploy -o ${delegate}
	fi
	
	chmod +x ${delegate}
	
	${delegate} ${arguments[@]}
}

{
	self::prepare ${@}
	self::execute
}
