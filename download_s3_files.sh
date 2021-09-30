#!/bin/bash

DIST=$1
ARCH=$2
BASEURL=$3

if [ "${ARCH}" == "aarch64" ]; then
    ARCHTYPE="arm64"
else
    ARCHTYPE="amd64"
fi

S3CMD="sync"

DESTDIR="debs/${DIST}/"

echo "Baseurl: ${BASEURL}"

aws s3 ${S3CMD} --exact-timestamps --no-progress --endpoint-url "${AWS_ENDPOINT_URL}" --exclude '*' --include 'kanidm-latest-*.deb' "${BASEURL}" "${DESTDIR}"
aws s3 ${S3CMD} --exact-timestamps --no-progress --endpoint-url "${AWS_ENDPOINT_URL}" --exclude '*' --include 'kanidm-*-latest-*.deb' "${BASEURL}" "${DESTDIR}"
aws s3 ${S3CMD} --exact-timestamps --no-progress --endpoint-url "${AWS_ENDPOINT_URL}" --exclude '*' --include 'kanidmd-latest-*.deb' "${BASEURL}" "${DESTDIR}"
echo "Completed ${DIST} ${ARCH} to ${DESTDIR}"