# dotfiles

```console
git clone git@github.com:thomas-bouvier/dotfiles.git /home/tbouvier/Dev
```

## SSH key

[Generate](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a new key.

## Notes (obsidian)

Open Obsidian and sync your notes. Close the program.

```console
mv /home/tbouvier/Obsidian/<Vault>/.obsidian /home/tbouvier/Obsidian/<Vault>/.obsidian.old
ln -s /home/tbouvier/Dev/dotfiles/.obsidian /home/tbouvier/Obsidian/<Vault>
```

## Shell history (atuin)

Install [atui](https://docs.atuin.sh/guide/installation/). Set up the [sync](https://docs.atuin.sh/guide/sync/) using your credentials and secret key.

## Shell workflow (tmux)

```console
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s /home/tbouvier/Dev/dotfiles/tmux/.tmux.conf /home/tbouvier
tmux source-file /home/tbouvier/.tmux.conf
```

Press `prefix` + `I` to install the tmux plugins (the tmux config sets `prefix` to `C-x`)

Additional tmux shortcuts:

```console
cp /home/tbouvier/Dev/dotfiles/tmux/ide /usr/local/bin/ide
cp /home/tbouvier/Dev/dotfiles/tmux/g5k /usr/local/bin/g5k
```

## Shell configuration

```
ln -s /home/tbouvier/Dev/dotfiles/.zshrc /home/tbouvier
ln -s /home/tbouvier/Dev/dotfiles/.zsh_aliases /home/tbouvier
ln -s /home/tbouvier/Dev/dotfiles/ssh/config /home/tbouvier/.ssh
```

## Font

[JetBrains Mono](https://www.jetbrains.com/lp/mono/).


## NixOS

To rebuild the system:

```console
sudo nixos-rebuild switch --flake .
```
