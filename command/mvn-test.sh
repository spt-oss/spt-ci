#!/usr/bin/env bash

set -eu
set -o pipefail

function self::execute() {
	
	mvn verify ${@}
}

{
	self::execute ${@}
}
