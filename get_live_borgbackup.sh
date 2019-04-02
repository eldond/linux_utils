#!/bin/bash
# This script copies the "in-use" copy of borgbackup.sh from /bin and changes permissions so changes can be checked in. Also redacts the password.
# Run as root / sudo
cp /bin/borgbackup.sh .
chmod 777 borgbackup.sh
sed -i 's/BORG_PASSPHRASE=.*/BORG_PASSPHRASE=REDACTED/g' ./borgbackup.sh  # https://stackoverflow.com/a/9189153/6605826
sed -i '1s|^|EDIT THIS SCRIPT to put in the real passphrase (surrounded by single quotes)\ncopy it to /bin\nchmod 0700 on it so no one can read your passphrase\n|' ./borgbackup.sh  # https://stackoverflow.com/a/21574381/6605826

