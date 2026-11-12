# vim: ft=zsh
function setup_openssh(){
    sp "Enabling SSH services"
    waitkey
    systemctl --user enable ssh-agent.service
    sudo systemctl enable sshd.service
}
