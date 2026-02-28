# Installation instructions

You should probably follow the [NixOS manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation). I share my own notes for reference.

Download the [minimal ISO NixOS image](https://nixos.org/download/), and create a bootable USB drive following the instructions in [Section "Booting from a USB flash drive"](https://nixos.org/manual/nixos/stable/index.html#sec-booting-from-usb) of the NixOS manual. Identify your USB stick:

```console
lsblk
```

Copy the ISO to the USB stick (replace $DISK with your USB stick, it should be a `disk` not a `part`):

```console
sudo dd if=<ISO_FILE> of=$DISK bs=4M status=progress
```

In the UEFI menu, make sure that:

Once in the menu:

- Ensure Safe (Secure) Boot is Disabled.
- Ensure Fast Boot is Disabled.
- Ensure UEFI Mode is Enabled.
- Ensure Boot from USB is Enabled.

Boot the machine from this USB drive.

## Once on the live USB

The US layout is chosen by default.

```console
sudo loadkeys mod-dh-ansi-us
```

For other layouts like French or German, use `loadkeys fr` or `loadkeys de`.

We'll enable internet access before partitioning. Just run `nmtui`. Alternatively, use something like that:

```console
sudo systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid ""
set_network 0 psk ""
set_network 0 key_mgmt WPA-PSK
enable_network 0
quit
```

## Partitioning

### Manual partitioning

I recommend using the Disko partioning approach detailed in the next section instead of partitioning manually.

Once in the NixOS shell, identify the name of your system disk by using the `lsblk` command as follows:

```console
lsblk
```

The output from this command will look something like this:

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0   1,8T  0 disk
```

We'll use `fdisk` to partition the disk:

```console
sudo fdisk /dev/nvme0n1
```

You can hit `m` to list available commands.

Create partitions and swapfile...

Generate the configuration files `configuration.nix` and `hardware-configuration.nix` as follows:

```console
sudo nixos-generate-config --root /mnt
```

You can then edit the produced configuration:

```console
ls /mnt/etc/nixos
vim /mnt/etc/nixos/configuration.nix
```

Once you are done with a configuration, install the new machine as follows:

```console
sudo nixos-install
```

### Disko partitioning

As we will be using Disko to partition our system, we can safely get rid of the `fileSystems` and `swapDevices` definitions in `hardware-configuration.nix`.

Once in the NixOS shell, identify the name of your system disk by using the `lsblk` command as follows:

```console
lsblk
```

The output from this command will look something like this:

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0   1,8T  0 disk
```

In this example, an empty NVME SSD with 2TB space is shown with the disk name
"nvme0n1". Make a note of the disk name as you will need it later.

Your configuration needs to be saved on the new machine for example
as `/tmp/disko-configuration.nix`. You can do this using the `curl` command to download
from the url you noted above, using the `-o` option to save the file as
disk-config.nix. Your commands would look like this if you had chosen the hybrid
layout:

```console
cd /tmp
curl https://raw.githubusercontent.com/thomas-bouvier/my-dotfiles/main/hosts/cladosporium/disko-configuration.nix -o /tmp/disko-configuration.nix

# Alternatively
curl https://raw.githubusercontent.com/nix-community/disko/master/example/luks-btrfs-subvolumes.nix -o /tmp/disko-configuration.nix
```

Inside the `disko-configuration.nix` the device needs to point to the correct disk name. Open the configuration in your favorite editor i.e.:

```console
nano /tmp/disko-configuration.nix
```

Replace `<disk-name>` with the name of your disk obtained in Step 1.

```nix
# ...
main = {
  type = "disk";
  device = "<disk-name>";
  content = {
    type = "gpt";
# ...
```

Set a LUKS password in `/tmp/secret.key`:

```console
echo password > /tmp/secret.key
```

The following step will partition and format your disk, and mount it to `/mnt`.

**Please note: This will erase any existing data on your disk.**

```console
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disko-configuration.nix
```

You should see a confirmation input and several output lines around partitioning and formatting the disks(see below), and don’t worry if you receive an error (for isntance you forgot to add the password file) ‘cause you can re-run disko multiple times. If you are uncertain about the outcome, you can always check the disko command’s return with `echo $?`:

```console
[..]
+ mountpoint=
+ type=btrfs
+ findmnt /dev/mapper/nixos /mnt/nix
+ mount /dev/mapper/nixos /mnt/nix -o compress=zstd -o noatime -o ssd -o space_cache=v2 -o user_subvol_rm_allowed -o subvol=@nix -o X-mount.mkdir
+ rm -rf /tmp/nix-shell-2791-0/tmp.jzrZ2yCjqz

$ echo $?
0
```

After the command has run, your file system should have been formatted and
mounted. You can verify this by running the following command:

```console
mount | grep /mnt
```

The output should look like this if your disk name is `nvme0n1`.

```
/dev/nvme0n1p1 on /mnt type ext4 (rw,relatime,stripe=2)
/dev/nvme0n1p2 on /mnt/boot type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
```

## Apple Silicon machine

Copy the peripheral firmware files off the EFI system partition (e.g. on the installation ISO `mkdir -p /mnt/etc/nixos/firmware && cp /mnt/boot/asahi/{all_firmware.tar.gz,kernelcache*} /mnt/etc/nixos/firmware`).

## First NixOS installation

Your disks have now been formatted and mounted, and you are ready to complete
the NixOS installation as described in the
[NixOS manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation) -
see the section headed "**Installing**", Steps 3 onwards. 

### You did not use Disko

```console
sudo nixos-generate-config --root /mnt
```

Set an `initialPassword` for your user.

git
experimental-features nix-command and flakes

```console
sudo nixos-install
reboot
```

### You used Disko

You will need
to include the partitioning and formatting configurations that you copied into
`/tmp/disko-configuration.nix` in your configuration, rather than allowing NixOS to
generate information about your file systems. When you are configuring the
system as per Step 4 of the manual, you should:

a) Include the `no-filesystems` switch when using the `nixos-generate-config`
command to generate an initial `configuration.nix`. You will be supplying the
file system configuration details from `disk-config.nix`. Your CLI command to
generate the configuration will be:

```console
sudo nixos-generate-config --no-filesystems --root /mnt
```

This will create the file `configuration.nix` in `/mnt/etc/nixos`.

b) Move the `disko` configuration to /etc/nixos

```console
mv /tmp/disko-configuration.nix /mnt/etc/nixos
```

c) You can now edit `configuration.nix` as per your requirements. This is
described in Step 4 of the manual. For more information about configuring your
system, refer to the NixOS manual.
[Chapter 6, Configuration Syntax](https://nixos.org/manual/nixos/stable/index.html#sec-configuration-syntax)
describes the NixOS configuration syntax, and
[Appendix A, Configuration Options](https://nixos.org/manual/nixos/stable/options.html)
gives a list of available options. You can find also find a minimal example of a
NixOS configuration in the manual:
[Example: NixOS Configuration](https://nixos.org/manual/nixos/stable/index.html#ex-config).

d) When editing `configuration.nix`, you will need to add the `disko` NixOS
module and `disko-configuration.nix` to the imports section. This section will already
include the file `./hardware-configuration.nix`, and you can add the new entries
just below this. This section will now include:

```nix
imports =
 [ # Include the results of the hardware scan.
   ./hardware-configuration.nix
   "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
   ./disko-configuration.nix
 ];
```

e) If you chose the hybrid-partition scheme, then choose `grub` as a bootloader,
otherwise follow the recommendations in Step 4 of the **Installation** section
of the NixOS manual. The following configuration for `grub` works for both EFI
and BIOS systems. Add this to your configuration.nix, commenting out the
existing lines that configure `systemd-boot`. The entries will look like this:

**Note:** It's not necessary to set `boot.loader.grub.device` here, since Disko
will take care of that automatically.

```nix
# ...
   #boot.loader.systemd-boot.enable = true;
   #boot.loader.efi.canTouchEfiVariables = true;
   boot.loader.grub.enable = true;
   boot.loader.grub.efiSupport = true;
   boot.loader.grub.efiInstallAsRemovable = true;
# ...
```

f) Finish the installation and reboot your machine,

```console
sudo nixos-install
reboot
```

## Complete installation

Once logged in in NixOS, clone this repository in the location of your choice `<current_config>` and follow steps documented in [README.md](README.md).

If you use an Apple Silicon machine, don't forget to copy your firmware files to the current configuration `cp /mnt/etc/nixos/firmware* <current_config>/system/asahi-firmware`.
