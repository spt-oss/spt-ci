#!/usr/bin/env bash

set -eu
set -o pipefail

function self::install() {
	
	# Create cache
	if [ ! -d brotli ]; then
		
		if [[ ! -x $(command -v make) ]]; then
			
			sudo apt-get -qq install make gcc
		fi
		
		git clone https://github.com/google/brotli.git
		
		pushd brotli/ > /dev/null
		
		make
		
		popd > /dev/null
	fi
	
	sudo cp -a brotli/bin/brotli /usr/local/bin/bro
}

{
	mkdir -p ${1}
	
	pushd ${1} > /dev/null
	
	self::install
	
	popd > /dev/null
	
	bro -h
}
