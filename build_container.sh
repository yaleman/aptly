#!/bin/bash

if [ "$(uname -m)" == "arm64" ]; then
    PLATFORM_FLAG="--platform x86_64"
else
    PLATFORM_FLAG=""
fi
#shellcheck disable=SC2086
docker build ${PLATFORM_FLAG} -t aptly-runner .