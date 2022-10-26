function setup_git-lfs() {
    sp "Installing Git LFS"
    git lfs install
}

function setup_git-credential-keepassxc() {
    echo "After syncing password database with Syncthing, unlock it and run:" >> ${CHEZMOI_REMINDERS}
    echo "\$ git-credential-keepassxc configure" >> ${CHEZMOI_REMINDERS}
    echo "" >> ${CHEZMOI_REMINDERS}
}
