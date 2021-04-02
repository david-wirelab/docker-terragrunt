# Docker Terragrunt

[![Build Status](/api/badges/david-wirelab/docker-terragrunt/status.svg)](/david-wirelab/docker-terragrunt)

[Terragrunt](https://github.com/gruntwork-io/terragrunt/) running with Terraform version 0.13.4

## Content overview

### .gitignore

Defines objects to be ignored by Git.

### Dockerfile

Defines what is packaged into the container.

### .drone

Defines the pipeline steps.

The following variables are required:

| Name        | Description | Type | Default | Required |
|-------------|:-----------:|:-------:|:-------:|---------|
| TERRAFORM_VERSION | Version of Terraform | build-arg | N/A | true |
| TERRGRUNT_VERSION | Version of Terragrunt | build-arg | N/A | true |

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
matrix:
  TERRAFORM_VERSION:
    - 0.12.25
  TERRAGRUNT_VERSION:
    - 0.23.18

pipeline:

  build:
    image: docker:17.09.0-ce
    repo: github.com/david-wirelab/docker-terragrunt.git
    secrets: [ DOCKERHUB_USERNAME, DOCKERHUB_TOKEN ]
    dockerfile: Dockerfile
    force_tag: true
    build_args:
      - TERRAFORM_VERSION=${TERRAFORM_VERSION}
      - TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION}
    tags:
      - ${DRONE_COMMIT_SHA}
      - ${DRONE_BUILD_NUMBER}
      - v${TERRAGRUNT_VERSION}
    when:
      event: push
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

`docker build -t docker-terragrunt/v13 --build-arg TERRAFORM_VERSION=0.13.4 --build-arg TERRAGRUNT_VERSION=0.25.4 .`
