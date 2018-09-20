#!/usr/bin/env bash

set -eu
set -o pipefail

function self::install() {
	
	local archive=newrelic-java.zip
	
	echo 'Download: '${archive}
	
	curl -fsSLO https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/${archive}
	unzip -q ${archive}
	
	mv newrelic/newrelic.jar .
	
	rm -r newrelic/
	rm ${archive}
}

{
	mkdir -p ${1}
	
	pushd ${1} > /dev/null
	
	self::install
	
	popd > /dev/null
}
