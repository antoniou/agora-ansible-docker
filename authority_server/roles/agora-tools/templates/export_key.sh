#!/bin/bash
mkdir -p {{ key_mount_path }}
eopeers --show-mine | tee {{ own_key_name }} {{ certs_dest }}/{{ own_key_name }} >/dev/null
