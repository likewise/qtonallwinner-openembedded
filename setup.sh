#!/bin/sh

# this script must be sourced into the current shell
if [ "$0" = "./setup.sh" ]; then
	echo "ERROR: This script must be sourced (source ./setup.sh)"
	return 1
fi

# the shell must be bash (not dash)
if [ "$0" != "bash" ]; then
	echo "ERROR: Need a BASH shell. Run /bin/bash first, or permanently switch to BASH: sudo dpkg-reconfigure dash"
	return
fi

# optionally support the "bb" tool for inspection purposes
if [ -x ./bb/bin/bb ]; then
	echo "Found bb (experimental subcommand based bitbake), used for inspection only."
	eval "$(./bb/bin/bb init -)"
fi

# prevent running this twice, mostly disallowing to switch to another project
which bitbake >/dev/null
if [ $? -eq 0 ]; then
	echo "ERROR: Bitbake was already in PATH. $0 must be sourced only once in the current shell."
	return 1
fi

# now run the subsequent environment setup for OpenEmbedded / Bitbake
if [ -x openembedded-core/oe-init-build-env ]; then
	. openembedded-core/oe-init-build-env build
fi

