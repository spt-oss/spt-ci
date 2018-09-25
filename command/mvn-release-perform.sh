#!/usr/bin/env bash

set -eu
set -o pipefail

function self::execute() {
	
	echo ${@}
	
	mvn release:perform --batch-mode -Darguments=-DskipTests ${@}
}

{
	self::execute ${@}
}
