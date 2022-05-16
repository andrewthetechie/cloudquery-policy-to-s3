FROM bitnami/minideb:bullseye as builder

ARG TARGETPLATFORM
ARG CLOUDQUERY_VERSION="v0.23.2"

RUN apt-get update -y \
    && apt-get install -y curl unzip gpg 
COPY Docker/builder/rootfs /
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  AWSARCH=amd64 export CQARCH=amd64  ;; \
         "linux/arm64")  AWSARCH=aarch64 export CQARCH=arm64 ;; \
         *)    ARCH=amd64   ;; \
    esac \
    && curl -L "https://awscli.amazonaws.com/awscli-exe-linux-$AWSARCH.zip" -o "awscliv2.zip" \
    && curl -L "https://awscli.amazonaws.com/awscli-exe-linux-$AWSARCH.zip.sig" -o "awscliv2.sig" \
    && gpg --import aws-cli.key \
    && gpg --verify awscliv2.sig awscliv2.zip \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && /download-cloudquery.sh

FROM bitnami/minideb:bullseye

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN install_packages less groff ca-certificates git

COPY --from=builder /usr/local/aws-cli /usr/local/aws-cli
COPY --from=builder /cloudquery /bin/cloudquery
COPY Docker/final/rootfs /

RUN ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws \
    && ln -s /usr/local/aws-cli/v2/current/bin/aws_completer /usr/local/bin/aws_completer

ENV CQ_CONFIG_FILE=/opt/cloudquery/config.hcl
CMD ["/bin/policy-to-s3.sh"]