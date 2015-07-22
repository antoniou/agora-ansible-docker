#!/bin/bash

PACKAGE_DEPENDENCIES=( ansible-playbook vagrant )
ANSIBLE_VERSION=1.9
DIRS=( keys certs logs tests )
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

check_ansible_version() {
  ansible --version|head -1|awk '{ print $2 }'
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
  log "Creating directories ${DIRS[@]}"
  mkdir -p "${DIRS[@]}"
}

clean_up() {
  log "Removing temporary directories"
  for dir in "${DIRS[@]}";
  do
    rm -rf $dir/*
  done
}

clean_up_db() {
  log "Cleaning up database"
  vagrant ssh -c 'sudo -u eorchestra psql -c "delete from authority ; delete from session; delete from election;delete from message; delete from query_queue;  delete from task;"'
}

tail_logs() {
  log "Tailing logs from Authority Server"
  while true;
  do
    tail -f logs/*.log
    sleep 3
  done
}

while getopts "hvtr" opt; do
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
    r)
      log "Cleaning up"
      clean_up
      clean_up_db
      ;;
  esac
done


check_for_dependencies
launch_auth

[[ $TAIL_LOGS -eq 1 ]] && tail_logs
