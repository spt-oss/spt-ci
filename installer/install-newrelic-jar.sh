#!/usr/bin/env bash

set -eu
set -o pipefail

function self::prepare() {
	
	local archive=newrelic-java.zip
	
	# Create cache
	if [ ! -f ${archive} ]; then
		
		echo 'Download: '${archive}
		
		curl -fsSLO https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/${archive}
	fi
	
	unzip -q ${archive}
	
	mv newrelic/newrelic.jar /tmp
	rm -r newrelic/
}

function self::install() {
	
	local location=${1}
	
	mv /tmp/newrelic.jar ${location}
}

{
	mkdir -p ${1}
	
	pushd ${1} > /dev/null
	
	self::prepare
	
	popd > /dev/null
	
	mkdir -p ${2}
	
	pushd ${2} > /dev/null
	
	self::install ${2}
	
	popd > /dev/null
}
