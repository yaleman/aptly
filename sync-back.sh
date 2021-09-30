
aws s3 sync --no-progress --endpoint-url "${AWS_ENDPOINT_URL}" .aptly s3://${APTLY_CONFIG_BUCKET}/.aptly/
