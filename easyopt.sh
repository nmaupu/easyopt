## This program is free software. It comes without any warranty, to
## the extent permitted by applicable law. You can redistribute it
## and/or modify it under the terms of the Do What The Fuck You Want
## To Public License, Version 2, as published by Sam Hocevar. See
## http://sam.zoy.org/wtfpl/COPYING for more details.

declare -a EASYOPT_OPTS
declare -a EASYOPT_CALLBACKS
EASYOPT_OPTS=()
EASYOPT_CALLBACKS=()
EASYOPT_WARNING=""

#####
## Add opt and corresponding callback
## Params :
##   opt to add (getopt format)
##   corresponding callback to call when opt is invoked
easyopt_add() {
  local OPT=$1
  local CALLBACK=$2

  EASYOPT_OPTS=( "${EASYOPT_OPTS[@]}" "$OPT" )
  EASYOPT_CALLBACKS=( "${EASYOPT_CALLBACKS[@]}" "$CALLBACK" )
}

#####
## Display opts and callbacks
easyopt_display() {
  echo ${EASYOPT_OPTS[@]}
  echo ${EASYOPT_CALLBACKS[@]}
}

#####
## get args string in getopts format
easyopt_get_optargs() {
  echo ${EASYOPT_OPTS[@]} | tr -d " "
}

easyopt_warning_on() {
  EASYOPT_WARNING=":"
}
easyopt_warning_off() {
  EASYOPT_WARNING=""
}

#####
## Search an opt in opts list
## Params :
##   pattern to search
easyopt_search_opt() {
  local PAT=$1
  IDX=$(echo ${EASYOPT_OPTS[@]} | tr -s " " "\n" | grep --line-number "${PAT}" | cut -d":" -f1)
  [ "x${IDX}" != "x" ] && echo $((${IDX}- 1)) || echo -1
}

#####
## Parse opts and call corresponding callback
easyopt_parse_opts() {
  while getopts "${EASYOPT_WARNING}$(easyopt_get_optargs)" opt
  do
    ## get index in opts array
    IDX=$(easyopt_search_opt ${opt})
    [ "$IDX" != "-1" ] && eval "${EASYOPT_CALLBACKS[${IDX}]}"
  done
}
