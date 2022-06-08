#!/bin/sh
# Downloads the correct version and ARCH of AWS 

set -e

echo "Target Platform is: ${TARGETPLATFORM}"
case ${TARGETPLATFORM} in
         "linux/amd64")  AWSARCH=x86_64;;
         "linux/arm64")  AWSARCH=aarch64;;
         *) AWSARCH=x86_64;; 
esac 
echo "AWSARCH is: ${AWSARCH}"

# downloads
curl -L "https://awscli.amazonaws.com/awscli-exe-linux-$AWSARCH.zip" -o "awscliv2.zip"
curl -L "https://awscli.amazonaws.com/awscli-exe-linux-$AWSARCH.zip.sig" -o "awscliv2.sig"

# gpg verify
gpg --import aws-cli.key
gpg --verify awscliv2.sig awscliv2.zip

# install
unzip -q awscliv2.zip
./aws/install