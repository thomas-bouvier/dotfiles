# dotfiles

## General utilities

```
dnf install zsh tmux
```

## SSH key

[Generate](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a new key.

## Shell history

Install [atui](https://docs.atuin.sh/guide/installation/). Set up the [sync](https://docs.atuin.sh/guide/sync/) using your credentials and secret key.

## Shell utilities

```
ln -s /home/tbouvier/Dev/dotfiles/.zshrc /home/tbouvier
ln -s /home/tbouvier/Dev/dotfiles/.zsh_aliases /home/tbouvier
ln -s /home/tbouvier/Dev/dotfiles/tmux/.tmux.conf /home/tbouvier
ln -s /home/tbouvier/Dev/dotfiles/ssh/config /home/tbouvier/.ssh

cp /home/tbouvier/Dev/dotfiles/tmux/ide /usr/local/bin/ide
cp /home/tbouvier/Dev/dotfiles/tmux/g5k /usr/local/bin/g5k
```

```
tmux source-file /home/tbouvier/.tmux.conf
```
