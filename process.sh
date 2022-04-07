#!/bin/bash

aptly version

exit 1


cd /data || exit 1

echo "####################################"
echo "Setting up environment"
echo "####################################"
./init_environment.sh

echo "####################################"
echo "Removing the .aptly dir"
echo "####################################"

rm -rf .aptly

echo "####################################"
echo "Grabbing the latest packages"
echo "####################################"
./grab_files_from_s3.sh || exit 1

echo "####################################"
echo "Updating the repository"
echo "####################################"
./update-repo.sh || exit 1

# echo "####################################"
# echo "Backing up the .aptly dir"
# echo "####################################"
# # ./sync-back.sh

echo "####################################"
echo "All done!"
echo "####################################"
