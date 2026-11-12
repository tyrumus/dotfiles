# vim: ft=zsh
function setup_virt_manager(){
    sp "Setting up libvirt group membership"
    waitkey
    sudo usermod -aG libvirt "$USER"
}
