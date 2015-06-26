#!/bin/bash
render_templates -v /etc/render.d

# Generate ssl certificate
gen_ssl_cert $@

nginx -g 'daemon off;'
