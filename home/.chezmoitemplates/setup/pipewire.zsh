# vim: ft=zsh
function setup_pipewire(){
    sp "Enabling PipeWire"
    waitkey
    systemctl --user enable pipewire.service
}
