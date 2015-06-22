FROM ubuntu:14.04

RUN apt-get update \
	&& apt-get install -y \
  {{ agora_core_packages|join(' ')}}
