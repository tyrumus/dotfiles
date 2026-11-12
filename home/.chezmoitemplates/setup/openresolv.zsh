# vim: ft=zsh
function setup_openresolv(){
    # if we're in WSL
    if [ ! -d "/mnt/c/Windows" ]; then
        sp "Setting up DNS"
        waitkey
        sudo rm /etc/resolv.conf
        sudo ln -s ../run/systemd/resolve/stub-resolv.conf
        sudo systemctl unmask systemd-resolved
        sudo systemctl enable --now systemd-resolved
    fi
}
