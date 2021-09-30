#!/bin/bash

echo "Cleaning up repo $1"

aptly-cmd repo remove "kanidm-$1" kanidmd
aptly-cmd repo remove "kanidm-$1" kanidm
aptly-cmd repo remove "kanidm-$1" kanidm-ssh
aptly-cmd repo remove "kanidm-$1" kanidm-unixd
aptly-cmd repo remove "kanidm-$1" kanidm-pamnss
