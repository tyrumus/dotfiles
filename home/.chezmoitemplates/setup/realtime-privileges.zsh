# vim: ft=zsh
function setup_realtime_privileges(){
    sp "Setting up realtime audio groups"
    waitkey
    sudo usermod -aG realtime,audio "$USER"
}
