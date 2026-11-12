# vim: ft=zsh
function setup_cifs_utils(){
    sp "Enabling Samba automounts"
    waitkey
    sudo systemctl enable srv-backup.automount
    sudo systemctl enable srv-oldbackup.automount
    sudo systemctl enable srv-public.automount
}
