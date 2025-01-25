{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../system/configuration.nix

      # Users
      ../../users/thomas.nix
      ../../users/famille.nix
    ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_acpi" ];
    initrd.kernelModules = [ ];

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  networking.hostName = "coprin";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # https://discourse.nixos.org/t/nixos-rebuild-remote-deployments-non-root-pam/50477
  security.pam = {
    # Enable the ssh-agent of a user to be used to authenticate them.
    sshAgentAuth.enable = true;
    # Allow ssh-agent authentication to give authorization to use sudo.
    services.sudo.sshAgentAuth = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [
    {
      device = "/.swapfile";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0f0u10.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
