#!/bin/bash
cert_dir={{ key_mount_path }}

for pkg in $cert_dir/*.pkg
do
  base=${pkg##*/}
  [[ "$base" == 'my_auth.pkg' ]] && continue
  eopeers --install $pkg
done
