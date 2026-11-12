# vim: ft=zsh
function setup_kexec_tools(){
    sp "Enabling kexec services"
    waitkey
    sudo systemctl enable unmodeset.service
    if [[ -f /boot/vmlinuz-linux-lts ]]; then
        sudo systemctl enable kexec-load@linux-lts.service
    elif [[ -f /boot/vmlinuz-linux ]]; then
        sudo systemctl enable kexec-load@linux.service
    else
        sp "No kernel found to set for kexec-load service. Will need to be enabled manually."
    fi
}
