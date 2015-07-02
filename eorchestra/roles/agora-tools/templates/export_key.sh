#!/bin/bash
mkdir -p {{ key_mount_path }}
eopeers --show-mine | tee {{ key_mount_path }}/my_auth_key.pkg >/dev/null