{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../system/configuration.nix

      # We need Nvidia drivers
      ../../system/nvidia.nix
      # We need virtualisation capabilities
      ../../system/virtualisation.nix

      # Users
      ../../users/thomas-work.nix

      # Partitioning
      ./disko-configuration.nix
    ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ ];

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # Use the latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "cladosporium";

  zramSwap = {
    enable = true;
    memoryPercent = 90;
  };

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
