#!/bin/bash


# if [ "$(uname -m)" == "arm64" ]; then
#     PLATFORM_FLAG="--platform amd64"
#     echo "using x86_64 on arm"
# else
#     PLATFORM_FLAG=""
# fi
#shellcheck disable=SC2086
docker run -it --rm \
    -v "$(pwd):/data" \
    --network host \
    --env-file .env  \
    --name aptly aptly-runner \
    /data/process.sh

