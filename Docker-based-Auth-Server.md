# Docker-based Authorities

This document provides information on the build process of a Docker-Based Authority Server

## Building a new  Authority Docker Image

```
$ ansible-playbook -i hosts/all.yml  authority_server/build.yml
```

## Description



### The Runtime template-rendering mechanism

When an container boots up, several system and application configuration files are rendered, using the environment variables that are passed to the container as input arguments. For example, we want the application inside the container to connect to the right database endpoint, which is provided as an environment variable.

There is a simple and light-weight run-time rendering mechanism in place: The image includes a script under */usr/local/bin/render_templates*. The paths to the templates that need to be rendered are specified under <i>/etc/render.d/*.conf</i>. The template file should contain placeholders that are prefixed with "AGORAENV_"

To enable rendering a template during initialization:

1. Add the path to the template that needs to be rendered. E.g, to render file   /election-orchestra/base_settings.py:
  ```
    echo "/election-orchestra/base_settings.py" > /etc/render.d/election-orchestra.conf
  ```
  
2. In the template, define placeholders that refer to environment variables, prefixed with "AGORAENV_". For example, the application configuration file could look like:
  ```
  ROOT_URL = 'https://AGORAENV_HOST:AGORAENV_PORT/api/queues'
  PUBLIC_DATA_BASE_URL = 'https://AGORAENV_HOST:AGORAENV_PORT/public_data'
  SQLALCHEMY_DATABASE_URI = 'AGORAENV_DB_USER:AGORAENV_DB_PASSWORD@AGORAENV_DB_HOST/AGORAENV_DB_NAME'
  ```
  
  For each of the placeholders, there needs to be an environment variable passed to the docker container:
  
  | Placeholder   |  Env var needed  |
|---|---|
| AGORAENV_HOST  |   HOST |
| AGORAENV_DB_USER   | DB_USER  |
| AGORAENV_DB_NAME  | DB_NAME  |
