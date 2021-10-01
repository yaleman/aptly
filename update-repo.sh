#!/bin/bash

if [ "$(gpg --list-keys | grep -c "${SIGNING_KEY_ID}")" -ne 1 ]; then
    echo "signing key issues, should only be one, listing them then bailing:"
    gpg --list-keys
    exit 1
fi

#shellcheck disable=SC2044
for DIR in $(find ./debs/ -mindepth 1 -maxdepth 1 -exec basename {} \;); do
    APTLY_REPO="kanidm-${DIR}"
    if [ "$(./aptly-cmd repo list | grep -c "${APTLY_REPO}")" -eq 1 ]; then

        echo "Updating ${DIR}"
        SNAPSHOT_NAME="${DIR}$(date '+housenet-%Y-%m-%d-%H%M%S')"
        ./aptly-cmd repo add "${APTLY_REPO}" "debs/${DIR}" || exit 1

        echo "Creating snapshot"
        ./aptly-cmd snapshot create "${SNAPSHOT_NAME}" from repo "${APTLY_REPO}" || exit 1

        ./aptly-cmd publish switch "${DIR}" "s3:${S3_HOSTNAME}:${DIR}" "${SNAPSHOT_NAME}" 
        #echo "Dropping the previous publish..."
        #aptly-cmd publish drop "${DIR}" "s3:${S3_HOSTNAME}:${DIR}"
        APTLY_DEST="s3:${S3_HOSTNAME}:${DIR}"

        #echo "Publishing... "
        #aptly-cmd publish snapshot -force-overwrite "${SNAPSHOT_NAME}" "${APTLY_DEST}"

        echo "Done with ${DIR}"
        echo "########################################################"
    else
        echo "Couldn't find repo ${APTLY_REPO}, skipping."
    fi
done

echo "Exporting signing key"
gpg --export --armor "${SIGNING_KEY_ID}" > signing-key.txt || exit 1
aws --endpoint-url "${AWS_ENDPOINT_URL}" s3 cp signing-key.txt "s3://${S3_BUCKET}/" || exit 1
