#!/bin/sh

PROGNAME=$(basename $0)
VERSION="0.9.0"

usage() {
	echo "Usage: $PROGNAME [OPTIONS]"
	echo "This script copies(rsync) addons from OF_ROOT/addons to PROJ_ROOT/addons and then updates addons.make."
	echo "[Notice] This script doesn't update your project file. So you may have to do it by yourself or with ProjectGenerator."
	echo
	echo "Options:"
	echo "  -h, --help"
	echo "  -g, --git\t\tinclude git directories(default : exclude)"
	echo "  -e, --example\t\tinclude examples(default : exclude)"
	echo "  -p, --path <file>\tproject directory(default : [currentdir])"
	echo "  -s, --src <dir>\toverwrite addons directory(default : PROJ_ROOT/../../../addons)"
	echo "  -d, --dst <dir>\toverwrite destination directory(default : PROJ_ROOT/addons)"
	echo "  -a, --abs\tupdate addons.make using absolute path(default : relative)"
	echo "  -i, --interactive\tinteractive mode"
	echo
	exit 1
}

set -ueo pipefail
script_dir=$(cd "$(dirname "$0")"; pwd)
PATH="$PATH:$script_dir"
source pathlib.bash

INTERACTIVE=false
IGNORE_GIT=true
IGNORE_EXAMPLE=true
ABSOLUTE=false
PROJ_ROOT=
CONFIG_FILE=
ADDONS_DIR=
DST_DIR=

for OPT in "$@"
do
	case "$OPT" in
		'-h'|'--help' )
			usage
			exit 1
			;;
		'--version' )
			echo $VERSION
			exit 1
			;;
		'-g'|'--git' )
			IGNORE_GIT=false
			shift 1
			;;
		'-e'|'--example' )
			IGNORE_EXAMPLE=false
			shift 1
			;;
		'-p'|'--path' )
			PROJ_ROOT=$(path_standardize $2)
			shift 1
			;;
		'-d'|'--dst' )
			DST_DIR=$(path_standardize $2)
			shift 1
			;;
		'-s'|'--src' )
			ADDONS_DIR=$(path_standardize $2)
			shift 1
			;;
		'-i'|'--interactive' )
			INTERACTIVE=true
			shift 1
			;;
		'-a'|'--abs' )
			ABSOLUTE=true
			shift 1
			;;
		'--'|'-' )
			shift 1
			param+=( "$@" )
			break
			;;
		-*)
			echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
			exit 1
			;;
		*)
			if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
				#param=( ${param[@]} "$1" )
				param+=( "$1" )
				shift 1
			fi
			;;
	esac
done

CONFIG_FILE=$PROJ_ROOT/"addons.make"
if [ ! $ADDONS_DIR ]; then ADDONS_DIR=$(path_standardize "$PROJ_ROOT/../../../addons"); fi
if [ ! $DST_DIR ]; then DST_DIR=$(path_standardize "$PROJ_ROOT/addons"); fi

if [ ! -e $DST_DIR ]; then mkdir -p $DST_DIR; fi

RESULT=
copy() {
	for OPT in "$@"
	do
		NAME=${1#./}
		NAME=${NAME##*/}
		local COPY_FROM=""
		if [ ! -d $ADDONS_DIR ] || [ ! -d $ADDONS_DIR/$NAME ]; then
			echo "could not find $1"
			RESULT+=$1\\n
			shift 1
			continue
		fi
		local EX=""
		if $IGNORE_EXAMPLE; then EX+="--exclude=example* "; fi
		if $IGNORE_GIT; then EX+="--exclude=.git* "; fi
		echo "copying from $ADDONS_DIR/$NAME to $DST_DIR/$NAME"
		rsync -ar $EX $ADDONS_DIR/$NAME $DST_DIR
		if $ABSOLUTE; then
			RESULT+=$(path_get_absolute $DST_DIR/$NAME)\\n
		else
			RESULT+=$(path_get_relative $PROJ_ROOT $DST_DIR/$NAME)\\n
		fi
		shift 1
	done
}

updateConfig() {
	while read LINE
	do
		if [[ -z `echo $RESULT | grep "${LINE##*/}"` ]]; then
			RESULT+=$LINE\\n
		fi
	done < $CONFIG_FILE

	echo $RESULT > $CONFIG_FILE
}

if $INTERACTIVE; then
	echo 
	echo "Enter addon name with or without 'ofx'. blank to exit."
	printf :
	while read ADDON_NAME
	do
		if [ -z "$ADDON_NAME" ]; then break; fi
		copy ofx${ADDON_NAME#ofx}
		updateConfig
		RESULT=
		echo 
		echo "Enter addon name with or without 'ofx'. blank to exit."
		printf :
	done
else
	copy $(echo $(<$CONFIG_FILE))
	updateConfig
fi



