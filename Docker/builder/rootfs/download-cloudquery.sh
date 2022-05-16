#!/bin/sh
# Downloads the correct version and ARCH of cloudquery 

set -e

echo $CLOUDQUERY_VERSION
echo $CQARCH
echo "https://github.com/cloudquery/cloudquery/releases/download/$CLOUDQUERY_VERSION/checksums.txt"
echo "https://github.com/cloudquery/cloudquery/releases/download/$CLOUDQUERY_VERSION/cloudquery_Linux_$CQARCH"
curl -L "https://github.com/cloudquery/cloudquery/releases/download/$CLOUDQUERY_VERSION/cloudquery_Linux_$CQARCH" -o /cloudquery
curl -L "https://github.com/cloudquery/cloudquery/releases/download/$CLOUDQUERY_VERSION/checksums.txt" -o /checksums.txt
export DL_SHA=$(sha256sum /cloudquery | awk '{print $1}')
cat /checksums.txt 
grep "cloudquery_Linux_$CQARCH" /checksums.txt 
export CQ_SHA=$(grep "cloudquery_Linux_$CQARCH" /checksums.txt | grep -v zip | awk '{print $1}')

echo $DL_SHA
echo $CQ_SHA
if [ "$DL_SHA" = "$CQ_SHA" ]; then
    chmod +x /cloudquery
    exit 0
else
    exit 1
fi
