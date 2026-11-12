# vim: ft=zsh
function setup_sddm(){
    sp "Enabling SDDM"
    waitkey
    sudo systemctl enable sddm.service
}
