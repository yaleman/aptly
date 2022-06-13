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
        echo "Uhh... repo ${APTLY_REPO} already exists, can't really continue - run 'clean-repo.sh ${DIR}'"
        exit 1
    else

        create-repo.sh "${DIR}"
        # echo "####################################"
        # echo "Adding files to repo ${APTLY_REPO}"
        # #./aptly-cmd repo add "${APTLY_REPO}" "debs/${DIR}" || exit 1
        # find "debs/${DIR}" -type f -name '*.deb' -exec aptly-cmd repo add "${APTLY_REPO}" {} \;

        # SNAPSHOT_NAME="${DIR}$(date '+housenet-%Y-%m-%d-%H%M%S')"
        # echo "Creating snapshot ${SNAPSHOT_NAME} from repo ${APTLY_REPO}and"

        # ./aptly-cmd snapshot create "${SNAPSHOT_NAME}" from repo "${APTLY_REPO}" || exit 1

        # echo "Running ./aptly-cmd publish switch \"${DIR}\" \"s3:${S3_HOSTNAME}:${DIR}\" \"${SNAPSHOT_NAME}\" || exit 1"
        # ./aptly-cmd -force-overwrite publish switch "${DIR}" "s3:${S3_HOSTNAME}:${DIR}" "${SNAPSHOT_NAME}" || exit 1

        # aws --endpoint-url "https://${S3_HOSTNAME}" --delete s3 sync .aptly/public/buster/ "s3://${S3_BUCKET}/${DIR}/"
        # echo "Done with ${DIR}"
        # echo "########################################################"

    fi
done

echo "Exporting signing key"
gpg --export --armor "${SIGNING_KEY_ID}" > signing-key.txt || exit 1
aws --endpoint-url "${AWS_ENDPOINT_URL}" s3 cp signing-key.txt "s3://${S3_BUCKET}/" || exit 1
