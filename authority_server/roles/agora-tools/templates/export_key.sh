#!/bin/bash
mkdir -p {{ key_mount_path }}
eopeers --show-mine | tee {{ key_mount_path }}/{{ own_key_name }} >/dev/null
cp {{ key_mount_path }}/{{ own_key_name }} {{ certs_dest }}/{{ own_key_name }}
