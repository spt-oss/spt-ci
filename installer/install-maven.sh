#!/usr/bin/env bash

set -eu
set -o pipefail

function self::prepare() {
	
	# Check Java
	java -version > /dev/null
	
	if [[ -v CIRCLECI ]] && [[ $(find /opt -maxdepth 1 -type d | grep -c apache-maven-) == 1 ]]; then
		
		pushd /opt/apache-maven-* > /dev/null
		
		sudo ln -s ${PWD} /usr/local/apache-maven
		
		popd > /dev/null
		
	elif [[ ! -d /usr/local/apache-maven ]]; then
		
		sudo mkdir -p /usr/local/apache-maven/
	fi
}

function self::install() {
	
	local version=${1}
	local archive=apache-maven-${version}-bin.tar.gz
	
	# Create cache
	if [ ! -f ${archive} ]; then
		
		echo 'Download: '${archive}
		
		curl -fsSLO https://archive.apache.org/dist/maven/maven-3/${version}/binaries/${archive}
	fi
	
	tar zxf ${archive}
	
	sudo rm -rf /usr/local/apache-maven/*
	sudo mv apache-maven-${version}/* /usr/local/apache-maven/
	
	rmdir apache-maven-${version}/
}

{
	self::prepare
	
	mkdir -p ${1}
	
	pushd ${1} > /dev/null
	
	self::install ${@:2}
	
	popd > /dev/null
	
	mvn --version
}
