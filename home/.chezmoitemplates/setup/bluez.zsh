# vim: ft=zsh
function setup_bluez(){
    sp "Enabling Bluetooth"
    waitkey
    sudo systemctl enable bluetooth.service
}
