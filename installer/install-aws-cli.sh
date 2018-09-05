#!/usr/bin/env bash

set -eu
set -o pipefail

function self::install() {
	
	# Check Python
	python --version > /dev/null
	
	if [[ $(dpkg -l | grep -c python-dev) == 0 ]]; then
		
		sudo apt-get -qq install python-dev
	fi
	
	if [[ ! -x $(command -v pip) ]]; then
		
		curl -fsSL https://bootstrap.pypa.io/get-pip.py | sudo python
	fi
	
	sudo pip install --upgrade awscli
}

{
	self::install ${@}
	
	aws --version
}
