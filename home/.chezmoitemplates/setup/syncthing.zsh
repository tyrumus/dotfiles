# vim: ft=zsh
function setup_syncthing(){
    sp "Enabling Syncthing"
    waitkey
    sudo systemctl enable "syncthing@$USER.service"
}
