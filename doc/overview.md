# Docker-based Authorities

This document describes the build process of a Docker-Based Authority Server and provides information on how the Docker Image is build and deployed.

## 1. Overview

This repository provides an ansible playbook that:

1. Builds a Docker Image for an Agora Voting System Authority ([election-orchestra](https://github.com/agoravoting/election-orchestra) + [agora-tools](https://github.com/agoravoting/agora-tools)).
2. Deploys an Agora Voting System Authority, in a Vagrant-provisioned VM and by deploying the built Docker Image inside the VM.

## 2. Building a new  Authority Docker Image

To build a new Docker Image for Election-Orchestra, you will need to:

1. Optionally specify a version of the docker image you want to build by editing the configuration file (config.yml)

1. Run the build Ansible playbook

  ```
$ ansible-playbook -i hosts/all.yml  authority_server/build.yml
  ```

1. Upload your image to Dockerhub:

  ```
$ docker push dcent/election-orchestra
```

### Build process overview

When building a docker image for the Agora Voting Authority service, the following process takes place:

1. A base Docker image is built that only includes [election-orchestra](https://github.com/agoravoting/election-orchestra). The image is tagged with the name **dcent/election-orchestra-base**
2. The base docker image is used as a source image, to build a Docker image that includes [election-orchestra](https://github.com/agoravoting/election-orchestra) and [agora-tools](https://github.com/agoravoting/agora-tools). The image is named  **dcent/election-orchestra**

### Deploying an Authority Server

An Authority server can be deployed using the [README](../README.md) guide in this repository

### The Runtime template-rendering mechanism

When an container boots up, several system and application configuration files are rendered, using the environment variables that are passed to the container as input arguments. For example, we want the application inside the container to connect to the right database endpoint, which is provided as an environment variable.

There is a simple and light-weight run-time rendering mechanism in place: The image includes a script under */usr/local/bin/render_templates*. The paths to the templates that need to be rendered are specified under <i>/etc/render.d/*.conf</i>. The template file should contain placeholders that are prefixed with "AGORAENV_"

**To enable rendering a template during initialization**:

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

### The entrypoint script

When an Authority container starts, it runs an entrypoint script which is located in /usr/local/bin/run.sh. This script performs the following actions:

1. It executes (in alphabetical order) all the scripts that are located in directory **/etc/entrypoint.d/pre**
2. It starts all the supervised services ( nginx, election-orchestra)
3. It executes (in alphabetical order) all the scripts that are located in directory **/etc/entrypoint.d/post**



