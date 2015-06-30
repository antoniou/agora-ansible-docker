FROM {{ base_image }}

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y {{ apt_repositories|join(' ')}}

RUN apt-get update && \
    apt-get install -y {{ apt_packages|join(' ')}}

RUN pip install {{ pip_packages|join(' ')}}

RUN mkdir -p {{ required_directories|join(' ')}}

# Clone git repositories and install pip requirements
RUN {% for repo in git_repositories.values() %}
git clone {{ repo.name }} --branch {{ repo.branch }} {{ repo.dest }} && \
(pip install -r {{ repo.dest }}/requirements.txt || true )
{%- if repo != git_repositories.values()[-1] %} && \
{% endif -%}
{% endfor %}

ADD root_fs /
RUN chmod +x /usr/local/bin/*

workdir /vfork

env JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

run ./configure --enable-jgmpmee --enable-jecn && \
  make && make install && \
  cp .vfork_env /election-orchestra && \
  bash -l -c "source /election-orchestra/.vfork_env && vog -rndinit RandomDevice /dev/urandom" && \
  rm -rf /vfork

#RUN install_vfork {{ vfork_dest }} {{ eorchestra_dest }} && \
#    rm -rf {{ vfork_dest }}

WORKDIR {{ eorchestra_dest }}

# Add environment variables
{% for key, value in env_vars.iteritems() %}
ENV {{ key }} {{ value }}
{% endfor %}

EXPOSE {{ agora_core_view_port }}

CMD "run.sh"
