#!/bin/bash
PACKAGE_DEPENDENCIES=( ansible-playbook vagrant )
ANSIBLE_VERSION=1.9
DIRS=( keys certs logs tests )
_V=0 # Verbose flag
_D=0 # Demo flag
_T=0 # Tail logs flag
DEMO_DIR=tests/demo
CONFIG_FILE=eo_env.yml
AUTH_MEMBERS=2
AUTHORITIES=()
GREEN='\033[0;36m'
NC='\033[0m' # No Color

usage() {
  cat <<EOF
    Usage: $0 [options] environment
    -h    Display help message
    -v    Verbose mode
    -t    Tail the logs after launching an Authority Server
    -r    Clean-up and re-launch the Authority Server
    -d    Demo mode with default number of authorities=2
EOF
exit 1;
}

log () {
  if [[ $_V -eq 1 ]]; then
      printf "${GREEN}$@${NC}"
      echo ""
  fi
}

check_for_dependencies() {
  for d in "${PACKAGE_DEPENDENCIES[@]}";
  do
    command -v  $d >/dev/null 2>&1 || { echo >&2 "$d binary not found. Please make sure it is installed."; exit 1; }
  done
  check_ansible_version
}

update_ansible() {
  echo "Ansible version needs to be $ANSIBLE_VERSION or later. Please upgrade."
  exit 1
}

check_ansible_version() {
  v=$(ansible --version|head -1|awk '{ print $2 }')
  r=$ANSIBLE_VERSION
  [[ "$(( ${v::1} ))" -lt "$(( ${r::1} ))" ]] && update_ansible ;
  [[ "$(( ${v:2:1} ))" -lt "$(( ${r:2:1} ))" ]] && update_ansible ;
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
  vagrant ssh -c 'sudo useradd eorchestra'
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

create_authority_list() {
  for i in `seq 1 $AUTH_MEMBERS`;
  do
    AUTHORITIES+=("auth$i")
  done
}

demo() {
  log "In DEMO mode"
  create_authority_list
  authorities=("${AUTHORITIES[@]}")
  log "Launching ${#authorities[@]} authority servers"

  for auth in ${authorities[@]};
  do
   auth_dir=$DEMO_DIR/$auth

   log "Initializing Authority \"$auth\" in $auth_dir"
   mkdir -p $auth_dir && rsync -a . $auth_dir --exclude $auth_dir/tests
   cp $CONFIG_FILE.sample $auth_dir/$CONFIG_FILE
   modify_config_file $auth_dir/$CONFIG_FILE $auth
   [[ $auth == $authorities ]] && echo "AUTH_MEMBERS: 2" >> $auth_dir/$CONFIG_FILE

   log "Starting authority $auth..."
   rm -rf Vagrantfile
   args=""
   [[ $auth == $authorities ]]  && args="-v"
   cd $auth_dir && ./run_auth.sh $args
   cd ../../..
   git checkout Vagrantfile
  done

  copy_keys_between ${authorities[@]}
  log "Starting authority $auth..."
  [[ $_T -eq 1 ]] && tail -f $DEMO_DIR/${authorities}/logs/*.log
}

# Initialize the config file with the correct host-name
# modify_config_file(config_file, host_name)
modify_config_file() {
  if [[ $(uname|tr -d ' ') == 'Darwin' ]];
  then
      sed -i.bu "s/\(HOST:\).*/\1 ${2}/" $1 && rm $1.bu
  else
      sed -i "s/\(HOST:\).*/\1 ${2}/" $1
  fi
}

# Copy keys between authorities
copy_keys_between() {
  log "Copying keys between authority servers"
  authorities=$1
  for auth in ${authorities[@]};
  do
    auth_dir=$DEMO_DIR/$auth
    for other_auth in ${authorities[@]};
    do
      other_auth_dir=$DEMO_DIR/$other_auth
      [[  $auth == $other_auth ]] && continue
      log "Copying keys from $auth to $other_auth"
      key="$auth_dir/certs/my_auth.pkg"
      while [[ ! -f $key ]];
      do
        log "Key $key not available..."
        sleep 5
      done
      cp $auth_dir/certs/my_auth.pkg $other_auth_dir/keys/$auth.pkg
      cd $auth_dir &&  vagrant ssh -c 'sudo docker exec eorchestra supervisorctl restart all' && cd ../../..
    done
    sleep 20
  done
}

check_for_dependencies

while getopts "hvtrd" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    v)
      _V=1
      ;;
    t)
      _T=1
      ;;
    r)
      log "Cleaning up"
      clean_up
      clean_up_db
      ;;
    d)
      _V=1
      _D=1
      demo
      exit 0
  esac
done

launch_auth

[[ $_T -eq 1 ]] && [[ $_D -eq 0 ]] && tail_logs
exit 0
