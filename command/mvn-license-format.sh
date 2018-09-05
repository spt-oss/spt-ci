#!/usr/bin/env bash

set -eu
set -o pipefail

function self::execute() {
	
	mvn license:format
}

{
	self::execute ${@}
}
