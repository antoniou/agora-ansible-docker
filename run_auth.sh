#!/bin/bash

PACKAGE_DEPENDENCIES=( ansible-playbook vagrant )
DIRS=( keys certs logs)
_V=0
TAIL_LOGS=0

usage() {
  cat <<EOF
    Usage: $0 [options] environment
    -h    Display help message
    -v    Verbose mode
EOF
exit 1;
}

log () {
  if [[ $_V -eq 1 ]]; then
      echo "$@"
      echo ""
  fi
}

check_for_dependencies() {
  for d in "${PACKAGE_DEPENDENCIES[@]}";
  do
    command -v  $d >/dev/null 2>&1 || { echo >&2 "$d binary not found. Please make sure it is installed."; exit 1; }
  done
}

launch_auth() {
  log "Bringing VM machine up"
  vagrant up --no-provision
  log "Bringing VM machine up"
  vagrant rsync-auto &
  log "Starting provisioning of Authority Server"
  vagrant provision
}

create_dirs() {
  log "Creating directories $DIRS"
  mkdir -p $DIRS
}

tail_logs() {
  log "Tailing logs from Authority Server"
  tail -f logs/*.log
}

while getopts "hv" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    v)
      _V=1
      ;;
    t)
      TAIL_LOGS=1
      ;;
  esac
done


check_for_dependencies
launch_auth

[[ $TAIL_LOGS -eq 1 ]] && tail_logs
