ARG TARGETPLATFORM="linux/amd64"
ARG CLOUDQUERY_VERSION="v0.24.11"

FROM bitnami/minideb:bullseye as builderbase
RUN apt-get update && apt-get install -y curl unzip gpg ca-certificates

FROM builderbase as aws-builder

ARG TARGETPLATFORM="linux/amd64"
ARG CLOUDQUERY_VERSION="v0.24.11"

COPY Docker/aws-builder/rootfs /
RUN /download-aws.sh

FROM builderbase as cloudquery-builder

ARG TARGETPLATFORM
ARG CLOUDQUERY_VERSION

COPY Docker/cloudquery-builder/rootfs /
RUN /download-cloudquery.sh

FROM bitnami/minideb:bullseye

ENV TZ=Etc/UTC

COPY --from=aws-builder /usr/local/aws-cli /usr/local/aws-cli
COPY --from=cloudquery-builder /cloudquery /bin/cloudquery
COPY Docker/final/rootfs /

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && install_packages less groff ca-certificates git \
    && ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws \
    && ln -s /usr/local/aws-cli/v2/current/bin/aws_completer /usr/local/bin/aws_completer

ENV CQ_CONFIG_FILE=/opt/cloudquery/config.hcl
CMD ["/bin/policy-to-s3.sh"]