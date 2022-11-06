#!/usr/bin/env bash

export CI_PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/../"

die() {
  cat <<EOF >&2
Error: $@

Usage: ${0} -c GENIMAGE_CONFIG_FILE
EOF
  exit 1
}

# Parse arguments and put into argument list of the script
opts="$(getopt -n "${0##*/}" -o c: -- "$@")" || exit $?
eval set -- "$opts"


while true ; do
	case "$1" in
	-c)
	  GENIMAGE_CFG="${2}";
	  shift 2 ;;
	--) # Discard all non-option parameters
	  shift 1;
	  break ;;
	*)
	  die "unknown option '${1}'" ;;
	esac
done

[ -n "${GENIMAGE_CFG}" ] || die "Missing argument"

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

trap 'rm -rf "${GENIMAGE_TMP}"' EXIT
GENIMAGE_TMP="$(mktemp -d)"

mkdir -p "${ROOTPATH_TMP}/img/"
mkdir -p ${ROOTPATH_TMP}/img/Apps

## Copy AppImages from local directory
# cp /tmp/local/AppImages/Sparrow/output/Sparrow-1.5.2.glibc2.4-x86_64.AppImage ${ROOTPATH_TMP}/img/Apps/sparrow.AppImage
# cp /tmp/local/AppImages/Alacritty/output/Alacritty-v0.9.0.glibc2.18-x86_64.AppImage ${ROOTPATH_TMP}/img/Apps/alacritty.AppImage
# cp /tmp/local/AppImages/Kitty/output/kitty-0.23.1.glibc2.14-x86_64.AppImage ${ROOTPATH_TMP}/img/Apps/kitty.AppImage
# cp /tmp/local/AppImages/Electrum/output/electrum-4.1.5-x86_64.AppImage ${ROOTPATH_TMP}/img/Apps/electrum.AppImage
# cp /tmp/local/AppImages/Firefox/output/Firefox-91.3.0esr.glibc2.17-x86_64.AppImage ${ROOTPATH_TMP}/img/Apps/firefox.AppImage

# chmod a+x ${ROOTPATH_TMP}/img/Apps/*
# 
# if [[ -d /tmp/local/Data ]]; then
#   mkdir -p ${ROOTPATH_TMP}/img/Apps/Data/
#   cp -a /tmp/local/Data/* ${ROOTPATH_TMP}/img/Apps/Data/
# fi


rm -f ${CI_PROJECT_DIR}/output/disk.img
mkdir ${CI_PROJECT_DIR}/output
genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${CI_PROJECT_DIR}/assets"  \
	--outputpath "${CI_PROJECT_DIR}/output" \
	--config "${GENIMAGE_CFG}"

chown 1000 ${CI_PROJECT_DIR}/output/disk.img
