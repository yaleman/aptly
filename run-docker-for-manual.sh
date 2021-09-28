#!/bin/bash

docker run -it --rm -v "$(pwd):/data" --env-file .env --name aptly debian

