#!/usr/bin/env bash

set -eu
set -o pipefail

function self::execute() {
	
	# TODO https://issues.apache.org/jira/browse/MDEP-516
	# TODO https://issues.apache.org/jira/browse/MDEP-568
	#mvn dependency:go-offline
	
	# Install plugins, dependencies and artifacts
	mvn install --batch-mode -DskipTests -Dcheckstyle.skip=true ${@}
	
	# Install plugins after install
	mvn javadoc:help --batch-mode
}

{
	self::execute ${@}
}
