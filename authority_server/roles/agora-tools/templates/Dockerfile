FROM {{ base_image }}

{% if apt_repositories %}
    RUN apt-get install -y software-properties-common && \
        add-apt-repository -y {{ apt_repositories|join(' ')}}
{% endif %}

{% if apt_packages %}
    RUN apt-get update && \
        apt-get install -y {{ apt_packages|join(' ')}}
{% endif %}

{% if pip_packages %}
    RUN pip install {{ pip_packages|join(' ')}}
{% endif %}

{% if required_directories %}
    RUN mkdir -p {{ required_directories|join(' ')}}
{% endif %}

# Clone git repositories and install pip requirements
{% if git_repositories.values() %}
    RUN {% for repo in git_repositories.values() %}
        git clone {{ repo.name }} --branch {{ repo.branch }} {{ repo.dest }} && \
        (pip install -r {{ repo.dest }}/requirements.txt || true )
        {%- if repo != git_repositories.values()[-1] %} && \
        {% endif -%}
    {% endfor %}
{% endif %}

ADD root_fs /
RUN chmod +x /usr/local/bin/* && chmod +x /usr/bin/*

# Add environment variables
{% if env_vars %}
    {% for key, value in env_vars.iteritems() %}
        ENV {{ key }} {{ value }}
    {% endfor %}
{% endif %}