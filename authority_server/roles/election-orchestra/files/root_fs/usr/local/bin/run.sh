#!/bin/bash
ENTRYPOINT_COMMAND_DIR=/etc/entrypoint.d
SLEEP_INTERVAL=5

execute_commands() {
  for command in `ls $ENTRYPOINT_COMMAND_DIR/$1/*.sh`
  do
    chmod +x $command && . $command
  done
}

echo 'Executing "pre" commands'
execute_commands 'pre'

service supervisor start

echo 'Starting services'
while [[ $(supervisorctl status eorchestra|awk {'print $2'}) != 'RUNNING' ]]; do
  sleep $SLEEP_INTERVAL
done

echo 'Executing "post" commands'
execute_commands 'post'

tail -f /var/log/supervisor/*.log
