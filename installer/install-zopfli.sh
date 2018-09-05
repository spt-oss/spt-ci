#!/usr/bin/env bash

set -eu
set -o pipefail

function self::install() {
	
	# Create cache
	if [ ! -d zopfli ]; then
		
		if [[ ! -x $(command -v make) ]]; then
			
			sudo apt-get -qq install make gcc
		fi
		
		git clone https://github.com/google/zopfli.git
		
		pushd zopfli/ > /dev/null
		
		make
		
		popd > /dev/null
	fi
	
	sudo cp -a zopfli/zopfli /usr/local/bin/
}

{
	mkdir -p ${1}
	
	pushd ${1} > /dev/null
	
	self::install
	
	popd > /dev/null
	
	zopfli -h
}
