ARG TERRAFORM_VERSION=${TERRAFORM_VERSION}

FROM hashicorp/terraform:${TERRAFORM_VERSION}

ENV USERMAP_UID 1000
ENV HOME /home/runner

RUN mkdir -p $HOME

WORKDIR $HOME

RUN apk add --update --upgrade --no-cache bash git openssh shadow jq
RUN apk upgrade libtasn1
RUN apk upgrade musl
RUN apk upgrade curl
RUN apk upgrade libgcrypt

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
