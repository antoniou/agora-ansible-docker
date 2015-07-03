#!/bin/bash
mkdir -p {{ key_mount_path }}
eopeers --show-mine | tee {{ key_mount_path }}/{{ own_key_name }} >/dev/null