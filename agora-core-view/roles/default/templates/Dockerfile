FROM {{ base_image }}

RUN apt-get update \
	&& apt-get install -y \
  {{ agora_core_packages|join(' ')}}

RUN npm install -g {{ npm_packages|join(' ')}}

# Application Config
RUN git clone {{ repos.agoracore.repo }} --branch {{ repos.agoracore.branch }} \
 		--single-branch {{ repos.agoracore.dest }}
ADD avConfig.js {{ repos.agoracore.dest }}/avConfig.js
WORKDIR {{ repos.agoracore.dest }}

RUN npm install && bower install --allow-root && grunt build

# Nginx Configuration
ADD nginx.conf /etc/nginx/conf.d/agoracore.conf
ADD root_fs /

EXPOSE {{ agora_core_view_port }}

RUN chmod +x /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/render_templates
CMD "run.sh"
