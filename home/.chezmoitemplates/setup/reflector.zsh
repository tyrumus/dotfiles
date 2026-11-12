# vim: ft=zsh
function setup_reflector(){
    sp "Finding mirrors and enabling reflector updates"
    waitkey
    sudo systemctl start reflector
    sudo systemctl enable reflector.timer
}
