# Tyrumus's Dotfiles

If you came from [this Reddit post,](https://www.reddit.com/r/unixporn/comments/6drt6c/awesomewm_noobs_paradise/) you're probably looking for [this repo instead.](https://github.com/tyrumus/dotfiles-old)

This repo is managed by [chezmoi](https://www.chezmoi.io/)

## Setup

Install chezmoi with your distro's package manager, then run the following and answer the prompts:
```
chezmoi init https://github.com/tyrumus/dotfiles
```

You probably only want the `term` install mode, unless you were hoping to set up an entirely new Arch Linux install.

Install Mode | Required Storage
--- | ---
`term` | tiny
`full` workstation | 20 GiB
`full` laptop | ???

### `term`

Install chezmoi to `~/.local/bin`
```
sh -c "$(curl -fsLS get.chezmoi.io/lb)" && export PATH="$PATH:~/.local/bin"
```

Apply the dotfiles
```
chezmoi init https://github.com/tyrumus/dotfiles --apply
```

### `full`

Install dependencies on Arch Linux
```
# pacman -S chezmoi git zsh curl
```

Apply the dotfiles
```
chezmoi init https://github.com/tyrumus/dotfiles --apply
```

Logout of your session, and log back in. Enjoy!

## System Information

Some details about the current setup, and links to their respective install/config information (Arch Wiki preferred).

Component | Software
--- | ---
Distro | [Arch Linux](https://archlinux.org/)
Shell | [Zsh](https://wiki.archlinux.org/title/Zsh)
DE | [KDE](https://wiki.archlinux.org/title/KDE)
Terminal Emulator | [Kitty](https://wiki.archlinux.org/title/Kitty)
Text Editor | [Neovim](https://wiki.archlinux.org/title/Neovim)
Color scheme | [gruvbox](https://github.com/morhetz/gruvbox)
Music Player | [Spotify](https://wiki.archlinux.org/title/Spotify)

## Run unattended Arch Linux install

[Follow the Arch Linux install guide](https://wiki.archlinux.org/title/Installation_guide) to do the following:
1) Partition the target drive. No need to create filesystems, as the script will handle that.
2) Connect to the Internet

Here's the GPT layout the install script expects:
Partition Type | Recommended size
--- | ---
ESP | 512M
Linux swap | same size as RAM
Linux x86-64 root (/) | remainder of drive

### Running the Install Script

Once that's done, run the install script:
```
curl -L https://tyrumus.dev/ai | zsh
```

## TODO

- Rewrite OS install script using archinstall Python library instead. This will handle partitioning as well.
