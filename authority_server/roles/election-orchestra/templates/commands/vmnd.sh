#!/bin/bash
EORCHESTRA={{ eorchestra_dest }}
source $EORCHESTRA/.vfork_env
COMMAND="vmnd -i json {{ eorchestra_dest }}/datastore/private/$1/*/protInfo.xml {{ eorchestra_dest }}/datastore/private/$1/*/publicKey_json $2 $3"
echo "> vmnd.sh Executing $COMMAND"
$COMMAND
