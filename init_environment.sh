#!/bin/bash

# install packages and stuff

# apt-get update
# apt-get -y install curl gnupg2 vim awscli
# echo 'deb http://repo.aptly.info/ squeeze main' | tee /etc/apt/sources.list.d/aptly.list

# curl -s https://www.aptly.info/pubkey.txt | gpg --dearmor > /etc/apt/trusted.gpg.d/aptly.gpg
# apt-get update
# apt-get -y install aptly

if [ ! -f aptly.conf ]; then
    echo "Couldn't find aptly.conf key, trying to pull it from s3"
    aws --endpoint-url "${AWS_ENDPOINT_URL}" s3 cp "s3://${APTLY_CONFIG_BUCKET}/aptly.conf" ./aptly.conf
    if [ ! -f aptly.conf ]; then
        echo "Couldn't get aptly.conf from s3, bailing!"
        exit 1
    fi

fi

if [ ! -f key.asc ]; then
    echo "Couldn't find GPG Signing key, trying to pull it from s3"
    aws --endpoint-url "${AWS_ENDPOINT_URL}" s3 cp "s3://${APTLY_CONFIG_BUCKET}/key.asc" ./key.asc
    if [ ! -f key.asc ]; then
        echo "Attempted to get GPG signing key from S3, failed. Bailing!"
        exit 1
    fi

fi
gpg --import key.asc

if [ "$(gpg --list-keys | grep -c "${SIGNING_KEY_ID}")" -ne 1 ]; then
    echo "signing key issues, should only be one, listing them then bailing:"
    gpg --list-keys
    exit 1
fi