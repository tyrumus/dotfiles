# vim: ft=zsh
function setup_tlp(){
    sp "Enabling TLP"
    waitkey
    sudo systemctl enable tlp.service
}
