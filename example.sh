#!/bin/bash
##
## Stupid example of easyopt.sh usage
##

DIRNAME=$(dirname $0)
source ${DIRNAME}/easyopt.sh

usage() {
cat << EOF
Usage: $0 [options]

Mandatory options :
  -f file       file to apply some other options

options :
  -l            display number of lines in file given
  -c            display number of bytes in file given
  -g pattern    number of occurences of a pattern in file given
  -h            display help
EOF
}

number_of_lines() {
  echo -n "Number of lines : "
  cat $1 | wc -l
}

number_of_bytes() {
  echo -n "Number of bytes : "
  cat $1 | wc -c
}

occurences() {
  echo -n "Number of occurences [$1] : "
  grep "$1" $2 | wc -l
}

easyopt_add "l"  'export LINES="1"'
easyopt_add "c"  'export BYTES="1"'
easyopt_add "g:" 'export GREP="1" && export PATTERN="$OPTARG"'
easyopt_add "h"  'usage && exit 1'
easyopt_add "f:" 'export FILE="$OPTARG"'
easyopt_parse_opts "$@"

## Params verification
[ ! $FILE ] && exit 1
[ ! $LINES -a ! $BYTES -a ! $GREP ] &>/dev/null && echo "No option provided, nothing to display" 1>&2 && exit 2

## 
[ $LINES ] && number_of_lines $FILE
[ $BYTES ] && number_of_bytes $FILE
[ $GREP ]  && occurences $PATTERN $FILE

