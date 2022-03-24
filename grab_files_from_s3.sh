#!/bin/bash

# files



S3_BASE="s3://${PACKAGE_SOURCE_BUCKET}"
# echo "S3 source: ${S3_BASE}"

# debian

OS="debian"
for DIST in "buster" "bullseye"; do
	for ARCH in "aarch64" "x86_64"; do
	    echo "Updating ${S3_BASE}/${OS}/${DIST}/${ARCH}/"
	    ./download_s3_files.sh "${DIST}" "${ARCH}" "${S3_BASE}/${OS}/${DIST}/${ARCH}/"
	done
done

# ubuntu
OS="ubuntu"
for DIST in "bionic" "focal" "groovy" "hirsute" "impish"; do
    for ARCH in "aarch64" "x86_64"; do
        echo "Updating ${S3_BASE}/${OS}/${DIST}/${ARCH}/"
        ./download_s3_files.sh "${DIST}" "${ARCH}" "${S3_BASE}/${OS}/${DIST}/${ARCH}/"
        echo "Done updating ${S3_BASE}/${OS}/${DIST}/${ARCH}/"
    done
done
