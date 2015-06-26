#!/bin/bash
render_templates -v /etc/render.d
cd $agora_core_dir

cp avConfig.js $(find dist/ -name "avConfig*")

nginx -g 'daemon off;'
