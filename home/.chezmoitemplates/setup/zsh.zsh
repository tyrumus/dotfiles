# vim: ft=zsh
function setup_zsh(){
    sp "Generating post-install reminder file"
    mkdir -p "$HOME/.cache"
    cat >"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
#!/usr/bin/zsh

echo "Don't forget to configure the following stuff and things when you're ready:"
echo
EOL

{{ if eq .installprofile "workstation" }}
    cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "Edit the systemd network config file at /etc/systemd/network/50-wired.link"
echo "Ensure to update the MAC address for the ethernet card"
echo
EOL
{{ end }}

    if has_install_packages cifs-utils; then
        cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "Edit the Samba credentials file at /etc/samba/credentials/nas"
echo "It should contain the following:"
echo
echo "username=<samba_username>"
echo "password=<samba_password>"
echo
EOL
    fi

    if has_install_packages syncthing git-credential-keepassxc; then
        cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "After syncing password database with Syncthing, unlock it and run:"
echo '$ git-credential-keepassxc configure'
echo
EOL
    fi

    if has_install_packages spotify-launcher; then
        cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "Setup Spotify with spotify-launcher."
echo
EOL
    fi

    if has_install_packages realtime-privileges; then
        cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "Remember to append preempt=full to kernel parameters"
echo
EOL
    fi

    if has_install_packages git; then
        cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "Change the URL for remote origin to SSH"
echo
EOL
    fi

    cat >>"$HOME/.cache/chezmoi-reminders.zsh" <<'EOL'
echo "To stop these reminders, run:"
echo "rm ${0}"
EOL
}
