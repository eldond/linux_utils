EDIT THIS SCRIPT to put in the real passphrase (surrounded by single quotes)
copy it to /bin
chmod 0700 on it so no one can read your passphrase
#!/bin/sh

# Please call this script with an argument to restore a specific file (or folder and contents)
# It is recommended to run the restore somewhere temporary or isolated to avoid making a mess
# How about this?
# cd /tmp
# mkdir restore
# cd restore
# sudo borgrestore.sh home/eldond/Documents/cv

# Note: no leading / in paths in the backup.

# If this script fails and leaves the repo locked, unlock with:
# sudo borg break-lock /mnt/cifs_share/share_data/backups3/

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=/mnt/cifs_share/share_data/backups3/
# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE=REDACTED
# or this to ask an external program to supply the passphrase:
export BORG_PASSCOMMAND='pass show backup'


# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup restore interrupted >&2; exit 2' INT TERM

info "Starting restore from backup..."
echo "Trying to extract file: " $1
echo "You should target this at a specific file or folder using command-line arguments."
echo "With no argument, this script will try to restore the entire backup, "
echo "which probably isn't what's needed for spot checks!"
echo ""

if [ -z "$(service autofs status | grep Active:\ active)" ]
then
    service autofs start
else
    echo autofs already running
fi

info "Listing of $BORG_REPO :"
ls $BORG_REPO

ARCHIVE=$(borg list $BORG_REPO | tail -1 | cut -d' ' -f1)
echo 'Latest archive = '
echo "${ARCHIVE}"

# echo 'Contents = '
# borg list $BORG_REPO::$ARCHIVE

echo Extracting $1 ...
borg extract --verbose --list $BORG_REPO::$ARCHIVE $1

