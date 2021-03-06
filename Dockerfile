ARG TERRAFORM_VERSION=${TERRAFORM_VERSION}

FROM hashicorp/terraform:${TERRAFORM_VERSION}

ENV USERMAP_UID 1000
ENV HOME /home/runner

RUN mkdir -p $HOME

WORKDIR $HOME

RUN apk add --update --upgrade --no-cache bash git openssh shadow jq
RUN apk upgrade libtasn1=1.8.5-r0
RUN apk upgrade musl=1.1.20-r5
RUN apk upgrade curl=7.64.0-r2
RUN apk upgrade libgcrypt=1.8.5-r0

# Add non-root runner user
RUN groupadd -r runner && \
    useradd --no-log-init -u $USERMAP_UID -r -g runner runner && \
    groupadd docker && \
    usermod -aG docker runner

ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION}

ADD https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN chmod +x /usr/local/bin/terragrunt

RUN chown -R runner:runner $HOME \
    && chmod -R 700 $HOME \
    && chown -R runner:runner /usr/local/bin/terragrunt \
    && chmod -R 700 /usr/local/bin/terragrunt

USER ${USERMAP_UID}

CMD ["/usr/local/bin/terragrunt"]
