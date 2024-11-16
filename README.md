# Lix dotfiles

My declarative, reproducible system built using [Lix](https://lix.systems/).

## Installation

If you set up a new machine you should probably [generate](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a new SSH key.

Put your age keys here:

```console
cd /home/thomas/.config/sops/age/keys.txt
```

To rebuild the system:

```console
nixos-rebuild switch --flake . --use-remote-sudo
```

I got some inspiration from [geraldwuhoo](https://github.com/geraldwuhoo/nixos-config) to setup my system.

### Atuin

If you imported age keys, just login to retrieve your shell history:

```console
atuin login
atuin sync
```

## Tailscale

Connect your machine to your Tailscale network and authenticate in your browser:

```console
sudo tailscale up
```

In Dolphin (or somewhere else), use `smb://user@ip` to connect to a remote SMB share.

## TODO

These are not fully integrated yet.

### Obsidian

Open Obsidian and sync your notes. Close the program.

```console
mv /home/thomas/Obsidian/<Vault>/.obsidian /home/thomas/Obsidian/<Vault>/.obsidian.old
ln -s /home/thomas/Dev/dotfiles/.obsidian /home/thomas/Obsidian/<Vault>
```
