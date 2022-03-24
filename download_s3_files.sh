#!/bin/bash

DIST=$1
ARCH=$2
BASEURL=$3

# if [ "${ARCH}" == "aarch64" ]; then
#     ARCHTYPE="arm64"
# else
#     ARCHTYPE="amd64"
# fi

echo "Endpoint url: ${AWS_ENDPOINT_URL}"
S3CMD=sync

DESTDIR="debs/${DIST}/"

aws configure set default.s3.signature_version s3v4
echo "Baseurl: ${BASEURL}"

echo 'Grabbing kanidm-latest-*.deb'
aws --endpoint-url "${AWS_ENDPOINT_URL}" s3 sync --exact-timestamps --no-progress --exclude '*' --include 'kanidm-latest-*.deb' "${BASEURL}" "${DESTDIR}" || exit 1

echo 'Grabbing kanidm-*-latest-*.deb'
aws --endpoint-url "${AWS_ENDPOINT_URL}" \
    s3 ${S3CMD} \
    --exact-timestamps \
    --no-progress \
    --exclude '*' --include 'kanidm-*-latest-*.deb' "${BASEURL}" "${DESTDIR}" || exit 1

echo 'Grabbing kanidmd-latest-*.deb'
aws --endpoint-url "${AWS_ENDPOINT_URL}" \
    s3 ${S3CMD} \
    --exact-timestamps --no-progress \
    --exclude '*' --include 'kanidmd-latest-*.deb' "${BASEURL}" "${DESTDIR}" || exit 1

echo "Completed ${DIST} ${ARCH} to ${DESTDIR}"