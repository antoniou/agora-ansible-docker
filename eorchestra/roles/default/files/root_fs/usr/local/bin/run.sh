#!/bin/bash
ENTRYPOINT_COMMAND_DIR=/etc/entrypoint.d

for command in `ls $ENTRYPOINT_COMMAND_DIR/*.sh`
do
  chmod +x $command && . $command
done

service supervisor start