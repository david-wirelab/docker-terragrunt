ARG TERRAFORM_VERSION=${TERRAFORM_VERSION}

FROM hashicorp/terraform:${TERRAFORM_VERSION}

RUN apk add --update --upgrade --no-cache bash git openssh shadow jq
RUN apk upgrade libtasn1=1.8.5-r0
RUN apk upgrade musl=1.1.20-r5
RUN apk upgrade curl=7.64.0-r2
RUN apk upgrade libgcrypt=1.8.5-r0

ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION}

ADD https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN chmod +x /usr/local/bin/terragrunt

CMD ["/usr/local/bin/terragrunt"]
