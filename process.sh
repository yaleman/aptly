#!/bin/bash

cd /data || exit 1

echo "Setting up environment"
./init_environment.sh

echo "Pulling down the aptly dir"
#aws s3 sync  --no-progress --endpoint-url "${AWS_ENDPOINT_URL}" s3://${APTLY_CONFIG_BUCKET}/.aptly .aptly

echo "Grabbing the latest packages"
./grab_files_from_s3.sh || exit 1

echo "Updating the repository"
./update-repo.sh || exit 1

echo "Backing up the .aptly dir"
./sync-back.sh

echo "All done!"
