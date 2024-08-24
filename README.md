# dotfiles

[Generate](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a new SSH key.

## Notes (obsidian)

Open Obsidian and sync your notes. Close the program.

```console
mv /home/tbouvier/Obsidian/<Vault>/.obsidian /home/tbouvier/Obsidian/<Vault>/.obsidian.old
ln -s /home/tbouvier/Dev/dotfiles/.obsidian /home/tbouvier/Obsidian/<Vault>
```

## Shell history (atuin)

Install [atui](https://docs.atuin.sh/guide/installation/). Set up the [sync](https://docs.atuin.sh/guide/sync/) using your credentials and secret key.

## Font

[JetBrains Mono](https://www.jetbrains.com/lp/mono/).


## NixOS

To rebuild the system:

```console
sudo nixos-rebuild switch --flake .
```
