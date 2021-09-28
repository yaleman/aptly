#!/bin/bash

if [ -z "${1}" ]; then
    echo "Please specify a repo name"
    exit 1
fi

APTLY_DEST="s3:${S3_HOSTNAME}:${1}/"
APTLY_CONFIG_FILE="aptly.conf"

DIR_NAME="debs/${1}"
REPO_NAME="kanidm-${1}"

if [ ! -f "${APTLY_CONFIG_FILE}" ]; then
    echo "Can't find aptly.conf, bailing."
    exit 1
fi

if [ "$(./aptly-cmd repo list | grep -c "${REPO_NAME}")" -ne 0 ]; then
    echo "Repo already exists, bailing"
    exit 1
fi

if [ "$(gpg --list-keys | grep -c james)" -ne 1 ]; then
    echo "signing key issues, should only be one, listing them then bailing:"
    gpg --list-keys
    exit 1
fi

if [ ! -d "${DIR_NAME}" ]; then
    echo "Please grab some files to add, it gets weird otherwise."
    echo "Put them in: ${DIR_NAME}"
    echo ""
    #echo "Run the following commands when done:"
    #echo ""
    #echo "./aptly-cmd snapshot create \"${REPO_NAME}-init\" from repo \"${REPO_NAME}\""
    #echo "./aptly-cmd publish snapshot \"${REPO_NAME}-init\" \"${APTLY_DEST}\""
    exit 1
fi

echo "Creating distribution ${REPO_NAME}"

./aptly-cmd repo create -distribution="$1" -component=main "${REPO_NAME}" || exit 1


# mkdir -p "${DIR_NAME}"
echo "Adding files to ${REPO_NAME} from ${DIR_NAME}"
./aptly-cmd repo add "${REPO_NAME}" "${DIR_NAME}" || exit 1


echo "Creating initial snapshot"
./aptly-cmd snapshot create "${REPO_NAME}-init" from repo "${REPO_NAME}" || exit 1

echo "Publishing initial snapshot to ${APTLY_DEST}"

./aptly-cmd publish snapshot "${REPO_NAME}-init" "${APTLY_DEST}" || exit 1

echo "Done!"
