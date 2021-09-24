#!/bin/bash

# files
function download_files() {
    DIST=$1
    ARCH=$2
    BASEURL=$3

    if [ "${ARCH}" == "aarch64" ]; then
        ARCHTYPE="arm64"
    else
        ARCHTYPE="amd64"
    fi

    DESTDIR="debs/${DIST}/"

    aws s3 sync --endpoint-url "${AWS_ENDPOINT_URL}" "${BASEURL}kanidm-latest-${ARCHTYPE}.deb" "${DESTDIR}" || exit 1
    aws s3 sync --endpoint-url "${AWS_ENDPOINT_URL}" "${BASEURL}kanidmd-latest-${ARCHTYPE}.deb" "${DESTDIR}" || exit 1
    aws s3 sync --endpoint-url "${AWS_ENDPOINT_URL}" "${BASEURL}kanidm-pamnss-latest-${ARCHTYPE}.deb" "${DESTDIR}" || exit 1
    aws s3 sync --endpoint-url "${AWS_ENDPOINT_URL}" "${BASEURL}kanidm-ssh-latest-${ARCHTYPE}.deb" "${DESTDIR}" || exit 1
    aws s3 sync --endpoint-url "${AWS_ENDPOINT_URL}" "${BASEURL}kanidm-unixd-latest-${ARCHTYPE}.deb" "${DESTDIR}" || exit 1
}

AWS_ENDPOINT_URL=https://minio-v4.housenet.yaleman.org

S3_BASE="s3://${PACKAGE_SOURCE_BUCKET}"
# echo "S3 source: ${S3_BASE}"

# debian
OS="debian"
DIST="buster"
for ARCH in "aarch64" "x86_64"; do
    echo "Updating ${S3_BASE}/${OS}/${DIST}/${ARCH}/"
    download_files "${DIST}" "${ARCH}" "${S3_BASE}/${OS}/${DIST}/${ARCH}/" || exit 1
done

# ubuntu
OS="ubuntu"
for DIST in "bionic" "focal" "groovy"; do
    for ARCH in "aarch64" "x86_64"; do
        echo "Updating ${S3_BASE}/${OS}/${DIST}/${ARCH}/"
        download_files "${DIST}" "${ARCH}" "${S3_BASE}/${OS}/${DIST}/${ARCH}/" || exit 1
    done
done