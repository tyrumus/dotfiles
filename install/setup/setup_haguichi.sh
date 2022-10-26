function setup_haguichi() {
sudo cat >>/var/lib/logmein-hamachi/h2-engine-override.cfg <<EOL
Ipc.User {{ .chezmoi.username -}}
EOL
}
