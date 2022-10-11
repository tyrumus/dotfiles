# Tyrumus's Dotfiles

If you came from [this Reddit post,](https://www.reddit.com/r/unixporn/comments/6drt6c/awesomewm_noobs_paradise/) you're probably looking for [this repo instead.](https://github.com/tyrumus/dotfiles-old)

This new repo is managed by [chezmoi](https://www.chezmoi.io/)

## System Information

Some details about the current setup, and links to their respective install/config information (Arch Wiki preferred).

Component | Software
--- | ---
Distro | [Arch Linux](https://archlinux.org/)
Shell | [Zsh](https://wiki.archlinux.org/title/Zsh)
Display Manager | [greetd](https://wiki.archlinux.org/title/Greetd) with greeter [greetd-tuigreet](https://wiki.archlinux.org/title/Greetd#tuigreet)
Wayland Compositor | [Sway](https://wiki.archlinux.org/title/Sway)
Lockscreen | [swaylock-effects](https://github.com/jirutka/swaylock-effects)
App Launcher | [rofi-lbonn-wayland](https://aur.archlinux.org/packages/rofi-lbonn-wayland)
Panel | [waybar](https://github.com/Alexays/Waybar)
Widgets | [eww](https://github.com/elkowar/eww)
Notification Daemon | [dunst](https://wiki.archlinux.org/title/Dunst)
Terminal Emulator | [Kitty](https://wiki.archlinux.org/title/Kitty)
Text Editor | [Neovim](https://wiki.archlinux.org/title/Neovim)
File Manager | [ranger](https://wiki.archlinux.org/title/Ranger)
Color scheme | [gruvbox](https://github.com/morhetz/gruvbox)
Music Player | [Spotify](https://wiki.archlinux.org/title/Spotify)
Screenshot tool | [grimshot](https://github.com/swaywm/sway/blob/master/contrib/grimshot) / [grim](https://sr.ht/~emersion/grim/)

If you want to know more, see what's installed by default in the [install-utils script.](run_+02-install-utils.zsh.tmpl)

## Screenshot

![Epic screenshot of my setup](img/dotfiles-rice-aug2022.png)

## Setup
Install chezmoi with your distro's package manager, then run the following:
```
chezmoi init https://github.com/tyrumus/dotfiles.git
```

My `run` scripts are intended to deploy [an entirely new Arch Linux install.](https://github.com/tyrumus/dotfiles#run-unattended-arch-linux-install) **This will install tons of packages and enable systemd services.**

If you don't want my automated scripts to mess up your Linux install, run the following command:
```
chezmoi cd
sh install/disable-install.sh
exit
```

Finally, apply the dotfiles:
```
chezmoi apply
```

Logout of your session, and log back in. Enjoy!

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

- Make `install/arch-install.zsh` automatically set up partitioning
