#!/bin/bash

aptly-cmd publish drop $1 s3:minio.housenet.yaleman.org:$1
aws --endpoint-url https://minio.housenet.yaleman.org s3 rm --recursive s3://aptly/$1
