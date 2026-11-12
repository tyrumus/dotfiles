# vim: ft=zsh
function setup_wireplumber(){
    sp "Enabling WirePlumber"
    waitkey
    systemctl --user enable wireplumber.service
}
