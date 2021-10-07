#!/bin/bash

aptly-cmd publish drop $1 s3:minio-v4.housenet.yaleman.org:$1
aws --endpoint-url https://minio-v4.housenet.yaleman.org s3 rm --recursive s3://aptly/$1
