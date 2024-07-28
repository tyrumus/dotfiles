# Tyrumus's Dotfiles

If you came from [this Reddit post,](https://www.reddit.com/r/unixporn/comments/6drt6c/awesomewm_noobs_paradise/) you're probably looking for [this repo instead.](https://github.com/tyrumus/dotfiles-old)

This repo is managed by [chezmoi](https://www.chezmoi.io/)

## System Information

Component | Software
--- | ---
Distro | [Arch Linux](https://archlinux.org/)
Shell | [Zsh](https://wiki.archlinux.org/title/Zsh)
DE | [KDE](https://wiki.archlinux.org/title/KDE)
Terminal Emulator | [Kitty](https://wiki.archlinux.org/title/Kitty)
Text Editor | [Neovim](https://wiki.archlinux.org/title/Neovim)
Color scheme | [gruvbox](https://github.com/morhetz/gruvbox)
Music Player | [Spotify](https://wiki.archlinux.org/title/Spotify)

## Setup

Install Mode | Required Storage
--- | ---
`term` | 1.8 GiB
`full` workstation | 14.7 GiB
`full` laptop | 10 GiB

### Install Mode: `term`

This mode only installs utilities and Neovim in `~/.local/bin`, without using the system package manager.
It is intended to be extremely portable.

Install chezmoi to `~/.local/bin`
```
sh -c "$(curl -fsLS get.chezmoi.io/lb)" && export PATH="$PATH:~/.local/bin"
```

Install the dotfiles and follow the prompts.
```
chezmoi init https://github.com/tyrumus/dotfiles
chezmoi apply
```

### Install Mode: `full`

This mode installs all utilities and GUI programs that I use on a full, regular Arch Linux installation.
See **Run unattended Arch Linux install** for OS install details, as the rest of this section assumes a minimal Arch Linux install.

Install dependencies
```
# pacman -S chezmoi git zsh curl
```

Apply the dotfiles
```
chezmoi init https://github.com/tyrumus/dotfiles --apply
```

Logout of your session, and log back in. Enjoy!

## Run unattended Arch Linux install

[Follow the Arch Linux install guide](https://wiki.archlinux.org/title/Installation_guide) to boot an Arch Linux ISO and connect to the internet.

If on Wi-Fi, make sure to use the `iwd` package rather than some other configuration utility, as this install script will copy the config.

### Running the Install Script

Once that's done, run the install script and follow the prompts:
```
curl -L https://tyrumus.dev/ai | zsh
```
