function setup_desktop() {
sudo cat >>/usr/local/bin/win-reboot-now <<EOL
#!/bin/bash

# run this script only as root
if [ "\$EUID" != 0 ]; then
    sudo "\$0" "\$@"
    exit \$?
fi

efibootmgr -qn 0
systemctl reboot
EOL

sudo chmod +x /usr/local/bin/win-reboot-now

sudo cat >>/etc/sudoers.d/20-win-reboot <<EOL
greeter ALL=(ALL:ALL) NOPASSWD: /usr/local/bin/win-reboot-now
%sudo ALL=(ALL:ALL) NOPASSWD: /usr/local/bin/win-reboot-now
EOL
}
