#!/usr/bin/zsh
# vim: ft=zsh

# if we're not in WSL
if [ ! -d "/mnt/c/Windows" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

export CYCLES_ONEAPI_ALL_DEVICES=1
