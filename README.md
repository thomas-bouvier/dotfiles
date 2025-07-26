# Lix dotfiles

My declarative, reproducible system built using [Lix](https://lix.systems/).

## Installation

If you set up a new machine you should probably [generate](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a new SSH key pair. Put your keys in `/home/thomas/.ssh/`.

Put your age keys here:

```console
vim /home/thomas/.config/sops/age/keys.txt
```

To rebuild the system:

```console
nixos-rebuild switch --flake . --sudo
```

To rebuild a remote system locally, and deploy it:

```console
nixos-rebuild switch --flake .#coprin --target-host thomas@192.168.1.30 --sudo
```

### Apple Silicon machine

Copy the peripheral firmware files off the EFI system partition (e.g. on the installation ISO `mkdir -p /mnt/etc/nixos/firmware && cp /mnt/boot/asahi/{all_firmware.tar.gz,kernelcache*} /mnt/etc/nixos/firmware`). Then, once a NixOS is installed, copy these firmware files to the current configuration `cp /mnt/etc/nixos/firmware* <current_config>/system/asahi-firmware`.

## Manual configuration

Some packages require manual configuration.

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

## Useful commands

Optimize the Nix store by hard linking duplicate binaries. This shouldn't be needed with my current dotfiles though, as optimizations are performed automatically at build time.

```console
nix-store --optimise
```

The Nix store accumulates entries which are no longer useful. They can be deleted:

```console
nix-store --gc
```

Delete all generations older than a specific period (e.g. 30 days):

```console
nix-collect-garbage --delete-older-than 30d
```

## Future work

Limitations:

- (vscodium) I am currently using the VSCode spyware instead of VSCodium because of an incompatibility with Copilot Chat. This should [eventually be fixed](https://code.visualstudio.com/blogs/2025/06/30/openSourceAIEditorFirstMilestone).
- (zotero) Zotero is [not available yet on aarch64 platforms](https://github.com/zotero/zotero/issues/3515).
- (localsend) LocalSend can't receive files when dns0 is enabled.
- (librewolf) `privacy.resistFingerprinting = true` prevents media upload and Leboncoin login from working.

These would be nice to have.

- I would like to install the [Ophirofox](https://ophirofox.ophir.dev/) extension, which is not available on the Mozilla store.

These are not fully integrated yet.

- SDDM doesn't offer a keyboard layout selection, which is very annoying for non-US keyboard users. SDDM should be incubated into Plasma [at some point](https://invent.kde.org/plasma/plasma-desktop/-/issues/91).
- [Pinned favorites in kickoff menu](https://github.com/nix-community/plasma-manager/issues/376) is not supported by `plasma-manager` yet.

## Some resources I found useful

- [Introduction to Nix and NixOS](https://www.youtube.com/watch?v=QKoQ1gKJY5A&list=PL-saUBvIJzOkjAw_vOac75v-x6EzNzZq-) by Wil T
- I got some inspiration from [geraldwuhoo](https://github.com/geraldwuhoo/nixos-config)
- [NixOS Secrets Management](https://www.youtube.com/watch?v=6EMNHDOY-wo) by EmergentMind
- [Flakes + Home Manager Multiuser/Multihost Configuration](https://www.youtube.com/watch?v=e8vzW5Y8Gzg) by Chris McDonough
- [NixOS on Apple Silicon](https://yusef.napora.org/blog/nixos-asahi/) by sef
