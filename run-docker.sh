#!/bin/bash

docker run -it --rm \
    -v "$(pwd):/data" \
    --network host \
    --env-file .env \
    --name aptly aptly-runner \
    /data/process.sh

