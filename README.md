# LegoStax's Dotfiles

If you came from [this Reddit post,](https://www.reddit.com/r/unixporn/comments/6drt6c/awesomewm_noobs_paradise/) you're probably looking for [this repo instead.](https://github.com/legostax/dotfiles-old)

This new repo is managed by [chezmoi](https://www.chezmoi.io/)

## Setup
Install chezmoi with your distro's package manager, then run the following:
```
$ chezmoi init https://github.com/legostax/dotfiles.git
```

My `run_once` scripts are intended to deploy an entirely new Arch Linux install. [Following the steps here](https://gist.github.com/legostax/5e52f3b97e61cb5e25c989930b6fc240) enables them to run smoothly without needing to run any commands in this repo directly.

If you don't want my automated scripts to mess up your Linux install, run the following commands:
```
$ touch $HOME/.cache/chezmoi-paru
$ touch $HOME/.cache/chezmoi-install
$ touch $HOME/.cache/chezmoi-root
```

Finally, apply the dotfiles:
```
$ chezmoi apply
```

Logout of your session, and log back in. Enjoy!
