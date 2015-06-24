#!/bin/bash
render_templates -v /etc/render.d

cd $agora_core_dir
nginx -g 'daemon off;'
