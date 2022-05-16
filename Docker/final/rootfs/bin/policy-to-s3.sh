#!/bin/sh

# Runs a cloudquery policy and 

rundate=$(date +%s)
cloudquery --config $CQ_CONFIG_FILE policy "$@" --output-dir ./results

for result in ./*
do
  echo "$result"
  if [ -z "$AWS_ENDPOINT" ];
  then
    aws s3 cp $result "s3://$S3_BUCKET/$(basename $result)/$rundate.txt"
  else
    aws --endpoint-url=$AWS_ENDPOINT s3 cp $result "s3://$S3_BUCKET/$(basename $result)/$rundate.txt"
  fi
done
