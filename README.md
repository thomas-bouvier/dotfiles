# Lix dotfiles

My declarative, reproducible [NixOS](https://nixos.org/) system built using [Lix](https://lix.systems/). My configuration is designed to support multiple hosts—including an Apple Silicon MacBook—and multiple users, some of whom are reused across different hosts. It also incorporates advanced features such as LUKS encryption via `disko` and secrets management with `sops`. I've aimed for a balance between readability and completeness.

## Installation

Please follow my installation instructions in [INSTALL.md](INSTALL.md).

If you set up a new machine you should probably [generate](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) a new SSH key pair. Put your keys in `/home/thomas/.ssh/` once you're logged in in your new machine. Don't forget to set up a new password for your user using `passwd`.

Put your age keys here:

```console
vim /home/thomas/.config/sops/age/keys.txt
```

Now you are ready to clone this configuration. Update my user `thomas` with yours. Once you are ready, rebuild the system:

```console
nixos-rebuild switch --flake .#host --sudo

# Or, better
nh os switch . -H host
```

To rebuild a remote system locally, and deploy it:

```console
nixos-rebuild switch --flake .#coprin --target-host thomas@192.168.1.30 --sudo

# Or, better
nh os switch . -H coprin --target-host thomas@coprin.local
```

If you run out of memory, add parameters `--cores x` and `--max-jobs x` to the build command.

## Available hosts

This configuration supports multiple hosts as documented in [`hosts/README.md`](hosts/README.md).

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

These commands are run altogether when using:

```console
nh clean all --keep-since 30d
```

## Future work

Limitations:

- (nixos) error during stage 1: can’t mount `/mnt-root`
- (nixos) new generations are sometimes [not pushed into the boot menu](https://nixos.wiki/wiki/Bootloader#New_generations_are_not_in_the_boot_menu).
- (DNS4EU) I should find a way to enable DNSOverTLS with DNS4EU
- (librewolf) [camera and screen share do not work on video calls](https://codeberg.org/librewolf/issues/issues/2548)
- (librewolf) `privacy.resistFingerprinting = true` prevents media upload and Leboncoin login from working.
- (vscodium) [VSCodium is unable to install extensions onto remotes](https://github.com/NixOS/nixpkgs/issues/275669)

These are not fully integrated yet:

- SDDM doesn't offer a keyboard layout selection, which is very annoying for non-US keyboard users. SDDM should be incubated into Plasma [at some point](https://invent.kde.org/plasma/plasma-desktop/-/issues/91).

## Some resources I found useful

- [Introduction to Nix and NixOS](https://www.youtube.com/watch?v=QKoQ1gKJY5A&list=PL-saUBvIJzOkjAw_vOac75v-x6EzNzZq-) by Wil T
- I got some inspiration from [geraldwuhoo](https://github.com/geraldwuhoo/nixos-config)
- [NixOS Secrets Management](https://www.youtube.com/watch?v=6EMNHDOY-wo) by EmergentMind
- [Flakes + Home Manager Multiuser/Multihost Configuration](https://www.youtube.com/watch?v=e8vzW5Y8Gzg) by Chris McDonough
- [NixOS on Apple Silicon](https://yusef.napora.org/blog/nixos-asahi/) by sef
