#!/usr/bin/env bash

set -eu
set -o pipefail
#set -x

EXECUTOR=${BASH_SOURCE%/*}/../../../command/ecr-upload.sh

function test::before() {
	
	eval 'function ecr-upload() { source ${EXECUTOR} ${@}; }'
	eval 'function aws() { eval echo aws ${@}; }'
	eval 'function docker() { eval echo docker ${@}; }'
}

function test::after() {
	
	unset -f ecr-upload
	unset -f aws
	unset -f docker
}

function test::assert_image_error() {
	
	(ecr-upload) && return ${?}
	
	echo $( (ecr-upload 2>&1) ) | \
		grep 'Usage' || return ${?}
}

function test::assert_region_error() {
	
	(ecr-upload -t image) && return ${?}
	
	echo $( (ecr-upload -t image 2>&1) ) | \
		grep 'Usage' || return ${?}
}

function test::assert_normal() {
	
	ecr-upload -t .ecr.us-west-1. --build-arg a=b | \
		grep '^aws ecr get-login --region us-west-1$' || return ${?}
	
	ecr-upload -t .ecr.us-west-1. --no-include-email | \
		grep '^aws ecr get-login --no-include-email --region us-west-1$' || return ${?}
	
	ecr-upload -t .ecr.us-west-1. --build-arg a=b | \
		grep '^docker build --build-arg a=b -t .ecr.us-west-1.$' || return ${?}
	
	ecr-upload -t .ecr.us-west-1. --build-arg a=b | \
		grep '^docker push .ecr.us-west-1.$' || return ${?}
}

function test::run() {
	
	local status=0
	
	test::before
	
	test::assert_image_error && \
		test::assert_region_error && \
		test::assert_normal || status=${?}
	
	test::after
	
	exit ${status}
}

{
	test::run
}
