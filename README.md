# cloudquery-policy-to-s3
A docker container to run CloudQuery policy checks and upload the results to s3

A cloudquery policy is run and then all results for that run are then uploaded to s3 in a timestamped json for later review.

# Usage

```
docker run -it -e S3_BUCKET=test andrewthetechie/cloudquery-policy-to-s3:v0.23.2 run github.com/cloudquery-policies/aws//cis_v1.2.0

Starting policies run...

⌛policy "github.com/cloudquery-policies/aws" -  evaluating -                           6s [================================>-----------------------------|  Finished Checks: 21/39
SNIP
Finished policies run...

./results/aws.json
upload: results/aws.json to s3://test/aws/1652668959.json
```


# Environment Variables

This container is configured using environment variables. It supports all environment varliables that [CloudQuery uses for config](https://docs.cloudquery.io/docs/configuration/environment-variable-substitution/). It also uses:

* CQ_CONFIG_FILE - path to where your cloudquery config file is. Defaults to /opt/cloudquery/config.hcl. Mount your cloudquery config to this path
* S3_BUCKET - Str name of the s3 bucket to upload your policy runs to
* AWS_ENDPOINT - Str, url, useful if testing with localstack or using minio or other s3 compatible storage
* AWS_* - AWS environment variables for configuration

# Container

https://hub.docker.com/r/andrewthetechie/cloudquery-policy-to-s3

Containers are built from releases in this repo where the release version corresponds to a cloudquery version.