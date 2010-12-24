#!/bin/bash
##
## Other example of easyopt usage
## Provide a python SimpleHTTPServer to serve some files provided by stdin or by an option
## Port is also configurable

DIRNAME=$(dirname $0)
source ${DIRNAME}/easyopt.sh

DEFAULT_PORT=8000
SEPARATOR=","
HTTP_CMD="python -m SimpleHTTPServer"
TMP_DIR=/tmp/httpizer-${RANDOM}

##########
## Functions
##########
usage() {
cat << EOF
Script to provide files as http
Usage: $0 [options]

Options :
  -h        display this help
  -f file   server only this file
  -p port   change port (default:${DEFAULT_PORT})

if -f is not provided, read from stdin
EOF
}

start_server () {
  local port=$1
  ${HTTP_CMD} $port
}

create_link () {
  local file=$1
  base=`basename $file`
  ln -s $file ${TMP_DIR}/$base
}

prepare_from_stdin () {
  for line in `cat`
  do
    create_link $line
    printf "[%s]\n" $line
  done
}

##########
## Main script
##########
PORT=${DEFAULT_PORT}
easyopt_add "f:" 'FILE=$OPTARG'
easyopt_add "p:" 'PORT=$OPTARG'
easyopt_add "h"  'usage && exit 0'
easyopt_parse_opts $@
RES=$?
[ $RES -ne 0 ] && exit $RES

mkdir -p ${TMP_DIR} && \
  { [ $FILE ] && echo $FILE | prepare_from_stdin || prepare_from_stdin; } && \
  cd ${TMP_DIR} && \
  start_server ${PORT}

cd - &>/dev/null
rm -rf ${TMP_DIR}
