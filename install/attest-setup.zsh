#!/usr/bin/zsh

set -e

paru -S tpm2-totp-git

tpm2-totp --pcrs=0,7 generate

tpm2-totp calculate

echo "Remember to add 'sd-plymouth-tpm2-totp' to HOOKS"
