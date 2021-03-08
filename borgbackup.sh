EDIT THIS SCRIPT to put in the real passphrase (surrounded by single quotes)
copy it to /bin
chmod 0700 on it so no one can read your passphrase
#!/bin/sh

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
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

if [ -z "$(service autofs status | grep Active:\ active)" ]
then
    service autofs start
else
    echo autofs already running
fi

info "Listing of $BORG_REPO :"
ls $BORG_REPO

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude-if-present '.git' \
    --exclude '/home/*/.cache/*'    \
    --exclude '/home/eldond/.config/Slack/*' \
    --exclude '/var/cache/*'        \
    --exclude '/var/tmp/*'          \
    --exclude '/home/eldond/Downloads/*' \
    --exclude '/home/eldond/OMFIT-*/*' \
    --exclude '/home/eldond/PCSPS/*' \
    --exclude '/home/eldond/omas/*' \
    --exclude '/home/eldond/atom*/*' \
    --exclude '/home/eldond/jerkface/*' \
    --exclude '/home/eldond/linux_utils/*' \
    --exclude '/home/eldond/mdsplus/*' \
    --exclude '/home/eldond/omfit_util/*' \
    --exclude '/home/eldond/python_stuff/pgmpl/*' \
    --exclude '/home/eldond/python_stuff/pyqtmpl/*' \
    --exclude '/home/eldond/python_stuff/photoneut/*' \
    --exclude '/home/eldond/TOKSYS/mastu/*' \
    --exclude '/home/eldond/python_stuff/pgmpl/*' \
    --exclude '/home/eldond/Documents/epm/*/*' \
    --exclude '/home/eldond/Documents/atom2/*' \
    --exclude '/home/eldond/Documents/APS_2018/abstract_*/*' \
    --exclude '/home/eldond/Documents/APS_2018/omfit_presentation_*/*' \
    --exclude '/home/eldond/Documents/APS_2018/poster_*/*' \
    --exclude '/home/eldond/Documents/APS_2018/suli_abstract_*/*' \
    --exclude '/home/eldond/Documents/CAKE/FSM_*/*' \
    --exclude '/home/eldond/Documents/CAKE/paper_*/*' \
    --exclude '/home/eldond/Documents/demo_workshop_2018/poster_*/*' \
    --exclude '/home/eldond/Documents/EAST_PCS/notes_*/*' \
    --exclude '/home/eldond/Documents/PCS/collab_mtg_*/*' \
    --exclude '/home/eldond/Documents/PCS/docs/*' \
    --exclude '/home/eldond/Documents/PCS/5c339*/*' \
    --exclude '/home/eldond/Documents/PCS/pcs_doc/*' \
    --exclude '/home/eldond/Documents/physnotes/notes/*' \
    --exclude '/home/eldond/Documents/physnotes/solpsiter_workshop*/*' \
    --exclude '/home/eldond/Documents/PSI_2018/abstract_*/*' \
    --exclude '/home/eldond/Documents/PSI_2018/paper_*/*' \
    --exclude '/home/eldond/Documents/PSI_2018/poster_*/*' \
    --exclude '/home/eldond/Documents/PSI_2018/psi_abstract_*/*' \
    --exclude '/home/eldond/Documents/templates/beamer_d3d_template_*/*' \
    --exclude '/home/eldond/Documents/templates/MP_template_tex_*/*' \
    --exclude '/home/eldond/Documents/suli2018hl/*' \
    --exclude '/home/eldond/python_stuff/regression_notifications/*' \
    --exclude '/home/eldond/.config/google-chrome/*/*Cache*/*' \
    --exclude '/home/eldond/.config/google-chrome/CertificateTransparency/*' \
    --exclude '/home/eldond/.config/google-chrome/Default/IndexedDB/*' \
    --exclude '/home/eldond/.PyCharmCE2018.1/*' \
    --exclude '/home/eldond/.config/google-chrome/Default/Cookies*' \
    --exclude '/home/eldond/.local/share/RecentDocuments/*' \
    --exclude '/var/lib/upower/history-*.dat' \
    --exclude '/var/log/*' \
    --exclude '/home/eldond/PycharmProjects/omfit/.idea/*' \
    --exclude '/home/eldond/.config/google-chrome' \
    --exclude '/home/eldond/.local/share/baloo/index-lock' \
    --exclude '/home/eldond/Documents/personal/opc/*' \
    --exclude '/home/eldond/.config/skypeforlinux/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/detach_and_rad_ctrl/notes_5ccc53276221f76dfd31f924/*' \
    --exclude '/home/eldond/pcs/d3d/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/prad_asipp_expt/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/detach_and_rad_ctrl/LP_detach/805post_lp_detach_5d787ecdb2ceeb0001aa5d31/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/livia_solps_support/solps_custom_plots/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/detach_and_rad_ctrl/LP_detach/lp_detach_mp_5d67f273640e32177258959c/*' \
    --exclude '/home/eldond/miniconda3/*' \
    --exclude '/home/eldond/Documents/itpa_2020/presentation*/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/itpa_2020/presentation*/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/itpa_2020/itpa_divsol_2020/*' \
    --exclude '/home/eldond/Documents/iaea_2020/iaea_fec_2020/*' \
    --exclude '/home/eldond/Documents/MAST-U/notes_5cdb9998f1eef81b9b550d02/*' \
    --exclude '/home/eldond/Documents/psi_2020/paper_5e6baf6eaaf9cb00010a3c71/*' \
    --exclude '/home/eldond/Documents/experiments_and_research/planning/itpa_divsol_2020/itpa_divsol_2020/*' \
    --exclude '/home/eldond/.zoom/*' \
    --exclude '/home/eldond/.mozilla/*' \
    --exclude '/var/lib/selinux/targeted/active/modules/*' \
    --exclude '/home/eldond/.local/share/baloo/index' \
    --exclude '/root/.cache/*' \
    --exclude '/home/eldond/.local/share/Trash/*' \
    --exclude '/var/lib/systemd/coredump/*' \
    --exclude '/home/eldond/util/' \
    --exclude '/var/spool/abrt/' \
    --exclude '/home/eldond/.config/discord/' \
    --exclude '/var/lib/selinux/targeted/tmp/' \
    --exclude '/home/eldond/.local/lib/python3.8/site-packages/*' \
    --exclude '/var/lib/gdm/.cache/mesa_shader_cache/*' \
    --exclude '/var/lib/rpm/*' \
    --exclude '/home/eldond/tmp/*' \
    --exclude '/home/eldond/.config/google-chrome-unstable/Default/Service Worker/*' \
    --exclude '/home/eldond/.local/share/akonadi/*' \
    --exclude '/home/eldond/.config/google-chrome-unstable/' \
                                    \
    ::'{hostname}-{now}'            \
    /etc                            \
    /home                           \
    /root                           \
    /var                            \

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    3               \
    --keep-weekly   3               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}
