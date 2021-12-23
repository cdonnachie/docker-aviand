#!/bin/bash
set -e

testAlias+=(
	[aviand:trusty]='aviand'
)

imageTests+=(
	[aviand]='
		rpcpassword
	'
)
