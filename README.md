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

### Obsidian

Just open Obsidian, login and sync everything including community plugins and settings (`Active community plugin list` and `Installed community plugins` options). Wait for the end of the synchronization, and restart the app.

### Tailscale

Connect your machine to your Tailscale network and authenticate in your browser:

```console
sudo tailscale up
```

In Dolphin (or somewhere else), use `smb://user@ip` to connect to a remote SMB share.

## Future work

These would be nice to have.

- I would like to install the [Ophirofox](https://ophirofox.ophir.dev/) extension, which is not available on the Mozilla store.

These are not fully integrated yet.

- SDDM doesn't offer a keyboard layout selection, which is very annoying for non-US keyboard users. SDDM should be incubated into Plasma [at some point](https://invent.kde.org/plasma/plasma-desktop/-/issues/91).
- [Pinned favorites in kickoff menu](https://github.com/nix-community/plasma-manager/issues/376) is not supported by `plasma-manager` yet.
