function setup_pipewire() {
    systemctl enable --user pipewire.service
}

function setup_pipewire-pulse() {
    systemctl enable --user pipewire-pulse.service
}

function setup_flameshot() {
    systemctl enable --user flameshot.service
}

function setup_openssh() {
    if [[ ! ${CHEZMOI_CHASSIS} == "wsl" ]]; then
        systemctl enable --user ssh-agent.service
        sudo mkdir -p /etc/ssh/sshd_config.d

sudo cat >>/etc/ssh/sshd_config.d/10-chezmoi.conf <<EOL
Port 22
PermitRootLogin no
MaxAuthTries 3
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
AllowAgentForwarding no
AllowTcpForwarding no
GatewayPorts no
X11Forwarding no
TCPKeepAlive yes
Compression delayed
EOL
    fi
}

function setup_udiskie() {
    systemctl enable --user udiskie.service
}

function setup_greetd() {
    sudo rm /etc/greetd/config.toml
sudo cat >>/etc/greetd/config.toml <<EOL
[terminal]
vt = 1
[default_session]
{{- if eq .chassistype "desktop" }}
command = "tuigreet --remember --remember-session --power-reboot '/usr/local/bin/win-reboot-now'"
{{- else }}
command = "tuigreet --remember --remember-session"
{{- end }}
user = "greeter"
EOL
}
