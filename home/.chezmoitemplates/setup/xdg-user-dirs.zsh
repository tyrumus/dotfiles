# vim: ft=zsh
function setup_xdg_user_dirs(){
    sp "Setting up extra home folders"
    waitkey
    xdg-user-dirs-update
    mkdir -p "$HOME/rsync" "$HOME/notes"
}
