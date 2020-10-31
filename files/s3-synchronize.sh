#!/usr/bin/env bash
set -euo pipefail

#=======================================#
#-- S3 SYNCHRONIZE SCRIPT             --#
#-- Author : NoxInmortus (Alban E.G.) --#
#=======================================#

## {{{ Global variables
##------------------##
## Global Variables ##
##------------------##

SUBJECT="s3-synchronize"
VERSION="1.0.0 (18/03/2020)"
USAGE="Usage: ${0} -hv \n
-u : upload (local to remote) \n
-d : download (remote to local) \n
-l : local path to synchronize \n
-r : remote path to synchronize (s3 url format) \n
-c : s3cmd config file (mandatory)."
HELP="S3 synchronize script through s3cmd (both directions available). s3cmd binary required."
LOG="/var/log/${SUBJECT}.log"
DATE=$(date '+%F-%Hh')
## Global variables }}}
## {{{ Script variables
# SECONDS returns a count of the number of (whole) seconds the shell has been running.
startTime=${SECONDS}

# Used to check conflict
u_arg=false
d_arg=false
## Script variables }}}

## {{{ Option processing
##-------------------##
## Option processing ##
##-------------------##

# If there is no arguments display ${USAGE}
if [ $# == 0 ] ; then
    echo -e ${USAGE}
    exit 1;
fi

while getopts ":vhudl:r:c:" optname
  do
    case "${optname}" in
      "v")
        echo "Version ${VERSION}"
        exit 0;
        ;;
      "h")
        echo -e ${HELP}
        echo -e ${USAGE}
        exit 0;
        ;;
      "u")
        sync_way="upload"
        u_arg=true
        ;;
      "d")
        sync_way="download"
        d_arg=true
        ;;
      "l")
        LOCAL=${OPTARG}
        ;;
      "r")
        REMOTE=${OPTARG}
        ;;
      "c")
        CONFIG_FILE=${OPTARG}
        ;;
      "?")
        echo "Unknown option ${OPTARG}"
        exit 0;
        ;;
      ":")
        echo "No argument value for option ${OPTARG}"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $((${OPTIND} - 1))
## Option processing }}}

# -----------------------------------------------------------------
#  SCRIPT LOGIC GOES HERE
# -----------------------------------------------------------------

## Sanity Checks
if [[ -z ${LOCAL+x} ]]; then
  echo "You need to define local directory (with -l option)."
  exit 1
elif [[ -z ${REMOTE+x} ]]; then
  echo "You need to define remote directory (with -r option)."
  exit 1
elif [[ -z ${CONFIG_FILE+x} ]]; then
  echo "You need to define s3cmd config file (with -c option)."
  exit 1
fi

if [ ${u_arg} == ${d_arg} ]; then
  echo "You cannot use -u (upload) and -d (download) options at the same time."
  exit 1
fi

if [ ! -d ${LOCAL} ]; then
  echo "Your local path is not a directory."
  exit 1
fi

## Lockfile
(flock -x 200 || exit 1

if [ ${sync_way} == "upload" ]; then
  s3cmd -c ${CONFIG_FILE} sync -v --stats --progress --stop-on-error --delete-removed ${LOCAL} ${REMOTE}
elif [ ${sync_way} == "download" ]; then
  s3cmd -c ${CONFIG_FILE} sync -v --stats --progress --stop-on-error ${REMOTE} ${LOCAL}
  chmod 0700 ${LOCAL}
else
  echo "Error with sync_way variable."
  exit 1
fi

elapsedTime=$((${SECONDS} - ${startTime}))
echo "${SUBJECT} duration : $((${elapsedTime}/60)) min $((${elapsedTime}%60)) sec"

)200>/var/lock/${SUBJECT}.lock

exit 0
