#!/usr/bin/env bash

set -eu
set -o pipefail

function self::execute() {
	
	# TODO Rebuild Darguments
	mvn release:perform --batch-mode -Darguments=-DskipTests ${@}
}

{
	self::execute ${@}
}
