#!/bin/bash
# This script copies the "in-use" copy of borgbackup.sh from /bin and changes permissions so changes can be checked in. Also redacts the password.
# Run as root / sudo
echo "The files here (except for this note) should go in /etc" > etc/note.txt
echo "" >> etc/note.txt
cp /etc/auto.master etc/
cp /etc/auto.cifs etc/
cp /etc/credentials.txt etc/
chmod 777 etc/auto.*
chmod 666 etc/credentials.txt
sed -i 's/password=.*/password=REDACTED/g' etc/credentials.txt  # https://stackoverflow.com/a/9189153/6605826
sed -i '1s|^|EDIT THIS FILE to put in the real password (no quotes)\ncopy it to /etc\nchmod 0600 on it so no one can read your passphrase\nDelete all this junk\n|' etc/credentials.txt  # https://stackoverflow.com/a/21574381/6605826

