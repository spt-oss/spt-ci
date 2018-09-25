#!/usr/bin/env bash

set -eu
set -o pipefail

function self::execute() {
	
	mvn release:perform --batch-mode -Darguments=-DskipTests ${@}
}

{
	self::execute ${@}
}
