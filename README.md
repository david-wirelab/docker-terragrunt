# Docker Terragrunt

![Drone (cloud)](https://img.shields.io/drone/build/david-wirelab/docker-terragrunt)

[Terragrunt](https://github.com/gruntwork-io/terragrunt/) running with Terraform version 0.13.4

## Content overview

### .gitignore

Defines objects to be ignored by Git.

### Dockerfile

Defines what is packaged into the container.

### .drone.yml

Defines the pipeline steps.

The following variables are required:

| Name        | Description | Type | Default | Required |
|-------------|:-----------:|:-------:|:-------:|---------|
| TERRAFORM_VERSION | Version of Terraform | build-arg | N/A | true |
| TERRGRUNT_VERSION | Version of Terragrunt | build-arg | N/A | true |
| DOCKERHUB_USERNAME | Username for DockerHub | string | N/A | true |
| DOCKERHUB_TOKEN | Access token for DockerHub | string | N/A | true |

### LICENSE

MIT license file.

### README.md

This file.

## Usage

This container is used to deploy Terraform code to AWS executed by a CICD pipeline job
achieved by passing in `terragrunt` commands at runtime eg. `terragrunt init`.
Bare in mind the container has to have **AWS credentials/ARN role** passed in
so that it can connect and interact with AWS APIs.

### CICD (Drone ~> 1) execution

```yaml
kind: pipeline
name: docker-terragrunt

steps:
- name: build and publish
  image: plugins/docker
  dockerfile: Dockerfile
  environment:
    TERRAFORM_VERSION: 0.13.4
    TERRAGRUNT_VERSION: 0.25.4
  settings:
    repo: wirelab/docker-terragrunt
    username:
      from_secret: DOCKERHUB_USERNAME
    password:
      from_secret: DOCKERHUB_TOKEN
    build_args_from_env:
      - TERRAFORM_VERSION
      - TERRAGRUNT_VERSION
    tags:
      - ${DRONE_COMMIT_SHA}
      - ${DRONE_BUILD_NUMBER}
```

### Environmental variables

The container expects 2 (two) build time arguments so that it can build a desired
version of Terragrunt and Terraform. It also needs AWS credentials during runtime.

| Name        | Description | Type | Default | Required |
|-------------|:-----------:|:-------:|:-------:|---------|
| TERRAFORM_VERSION | Version of Terraform | build-arg | None | True |
| TERRGRUNT_VERSION | Version of Terragrunt | build-arg | None | True |
| AWS_ACCESS_KEY_ID | Valid AWS access ID | env | None | False |
| AWS_SECRET_ACCESS_KEY | Valid AWS secret key | env | None | False |

## Local build

```bash
docker build -t docker-terragrunt/v13 \
--build-arg TERRAFORM_VERSION=0.13.4 \
--build-arg TERRAGRUNT_VERSION=0.25.4 .
```
