# aptly things

Don't get into packaging, it's dumb and broken and you'll just end up angry. Go do something else.

## publishing a new repo

Make sure you've got all the files for the architectures in the source s3 bucket

Go drinking. It's more fun.

1. update `grab_files_from_s3.sh`
2. run that
3. `./create-repo.sh <repo>`




```


./aptly-cmd publish repo kanidm-hirsute 's3:${S3_HOSTNAME}:hirsute'
```