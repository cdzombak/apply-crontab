#!/usr/bin/env bash
set -eo pipefail
CRONTAB_DIR="${APPLY_CRONTAB_DIR:-$HOME/crontab.d}"
PAGER="${PAGER:-less}"
set -u

__APPLY_CRONTAB_VERSION__="<dev>"
PROGRAMNAME=$(basename "$0")

USAGE() {
	>&2 echo -en "Usage:\n$PROGRAMNAME [OPTIONS]\n\n"
	>&2 echo -en "With no options, $PROGRAMNAME updates the current user's crontab with the the contents of *.cron files from ~/crontab.d.\n\n"
	>&2 echo -en "The default source directory (~/crontab.d) can be changed by the environment variable CRONTAB_DIR.\n\n"
	>&2 echo -en "Options:\n"
	>&2 echo -en "  -i\n  \tInit: create the crontab.d directory, populate it with the output of 'crontab -l', and initialize a Git repo in it.\n"
	>&2 echo -en "  -p\n  \tPreview: do not write to crontab; instead, preview the output in your PAGER (default: less).\n"
	>&2 echo -en "  -h\n  \tPrint this help and exit.\n"
	>&2 echo -en "  -v\n  \tPrint version number and exit.\n\n"
	>&2 echo -en "Version:\n  $PROGRAMNAME $__APPLY_CRONTAB_VERSION__\n\n"
	>&2 echo -en "GitHub:\n  https://github.com/cdzombak/apply-crontab\n\n"
	>&2 echo -en "Author:\n  Chris Dzombak <https://www.dzombak.com>\n"
}

VERSION() {
	echo "$__APPLY_CRONTAB_VERSION__"
}

DO_PREVIEW=false
DO_INIT=false

while getopts ":hipv" ARG; do
	case $ARG in
		p)
			DO_PREVIEW=true
		;;
		i)
			DO_INIT=true
		;;
		v)
			VERSION
			exit 0
		;;
		h | *)
			USAGE
			exit 0
		;;
	esac
done

if [ "$DO_PREVIEW" = true ] && [ "$DO_INIT" = true ]; then
   >&2 echo "exactly one of options (-p, -i) may be given"
   exit 1
fi

if [ "$DO_INIT" = true ]; then
	mkdir "$CRONTAB_DIR"
	pushd "$CRONTAB_DIR"
	cat <<- EOF > ./00-header.cron
	# remember: cron hardcodes PATH to /usr/bin:/bin
	# uncomment & add to it here if desired:
	# PATH=/usr/bin:/bin

	# quick ref:
	# m  h  dom mon dow   command

EOF
	crontab -l > ./99-crontab.cron
	git init -b main
	popd
	exit 0
fi

TARGET_CMD="crontab -"
if [ "$DO_PREVIEW" = true ]; then
	TARGET_CMD="$PAGER"
fi

{
   echo -en "# Generated by $PROGRAMNAME from '$CRONTAB_DIR' $(date +%FT%T%Z).\n"
   echo -en "#\n"
   echo -en "# !!! THIS FILE WAS AUTOMATICALLY GENERATED !!!\n"
   echo -en "#     DO NOT EDIT IT DIRECTLY.\n"
   echo -en "#     YOUR CHANGES WILL BE LOST.\n#\n"
   echo -en "# Make changes in '$CRONTAB_DIR'/*.cron and apply them with $PROGRAMNAME.\n"
   echo -en "#\n\n"
   cat "$CRONTAB_DIR"/*.cron
} | $TARGET_CMD
