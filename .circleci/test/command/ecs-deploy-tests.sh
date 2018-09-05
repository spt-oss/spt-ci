#!/usr/bin/env bash

set -eu
set -o pipefail
#set -x

EXECUTOR=${BASH_SOURCE%/*}/../../../command/ecs-deploy.sh
DELEGATE=/tmp/ecs-deploy.sh~

function test::before() {
	
	eval 'function ecs-deply() { source ${EXECUTOR} ${@}; }'
	eval 'function aws() { echo "{}"; }'
	
	mkdir -p $(dirname ${DELEGATE})
	echo 'echo ecs-deploy ${@}' > ${DELEGATE}
}

function test::disable_delegate_mock() {
	
	rm ${DELEGATE}
}

function test::after() {
	
	unset -f ecs-deply
	unset -f aws
	
	rm ${DELEGATE} || :
}

function test::assert_image_error() {
	
	(ecs-deply) && return 1
	
	echo $( (ecs-deply 2>&1) ) | \
		grep 'Usage' | grep '\-i' || return ${?}
}

function test::assert_region_error() {
	
	(ecs-deply -i image) && return 1
	
	echo $( (ecs-deply -i image 2>&1) ) | \
		grep 'Usage' | grep '\-r' || return ${?}
}

function test::assert_normal() {
	
	ecs-deply -i image -r us-west-1 | \
		grep '^ecs-deploy -i image -r us-west-1$' || return ${?}
	
	ecs-deply -i .ecr.us-west-1. | \
		grep '^ecs-deploy -i .ecr.us-west-1. -r us-west-1$' || return ${?}
	
	ecs-deply -i .ecr.us-west-1. -n service | \
		grep '^ecs-deploy -n service -i .ecr.us-west-1. -r us-west-1$' || return ${?}
	
	ecs-deply -i .ecr.us-west-1. -n service -c cluster | \
		grep '^ecs-deploy -n service -c cluster -i .ecr.us-west-1. -r us-west-1$' || return ${?}
}

function test::assert_delegate() {
	
	test::disable_delegate_mock
	
	ecs-deply -i .ecr.us-west-1. -n example && return 1
	
	echo $(ecs-deply -i .ecr.us-west-1. -n example) | \
		grep '\--cluster' || return ${?}
}

function test::run() {
	
	local status=0
	
	test::before
	
	test::assert_image_error && \
		test::assert_region_error && \
		test::assert_normal && \
		test::assert_delegate || status=${?}
	
	test::after
	
	exit ${status}
}

{
	test::run
}
