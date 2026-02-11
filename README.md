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

Install Profile | Required Storage
--- | ---
terminal | 9.2 GiB
laptop | 18 GiB
workstation | 24 GiB

### Install

This repository includes a series of bootstrap scripts that installs all utilities and GUI programs that I use, depending on the profile and settings selected in the script prompts.

#### Run unattended Arch Linux install

If you already have a basic Arch Linux install, skip to the **Alternative Setup Method** section.

[Follow the Arch Linux install guide](https://wiki.archlinux.org/title/Installation_guide) to boot an Arch Linux ISO and connect to the internet.

If on Wi-Fi, make sure to use the `iwd` package rather than some other configuration utility, as this install script will automatically copy the config.

#### Running the Install Script

Once that's done, run the install script and follow the prompts:
```
curl -L -o install.zsh https://tyrumus.dev/ai
zsh install.zsh
```

#### Alternative Setup Method
If you already have a minimal Arch Linux install - a shell and nothing else, simply install these dependencies before installing the dotfiles.

```
# pacman -S chezmoi git zsh curl
```

#### Install the Dotfiles
```
$ chezmoi init https://github.com/tyrumus/dotfiles --apply
```

Logout of your session, and log back in. Enjoy!
