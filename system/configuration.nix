# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
      ./bluetooth.nix
      ./stylix.nix
      ./tailscale.nix
      ./networking.nix
    ];

  # Enable system modules
  bluetooth.enable = true;
  
  stylix = {
    enable = true;
    #targets.qt.platform = "qtct";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8"];
  };

  services = {
    # KDE Plasma 6
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
      sddm.wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;

    # Enable CUPS to print documents.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    printing = {
      enable = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      drivers = [ pkgs.cnijfilter2 ];
    };

    # Enable sound.
    pulseaudio.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # Kwallet
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.kdewallet.enableKwallet = true;

  # Shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      vim
      zsh
      tmux
      git
      devenv
      tailscale
      wget
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "cnijfilter2"
      "unrar"
      # Nvidia
      "nvidia-x11"
      "nvidia-settings"
      # Apple
      "apple_cursor"
      "obsidian"
      # VSCode extensions
      "vscode-extension-ms-vscode-cpptools"
      "vscode-extension-ms-vscode-remote-remote-ssh"
    ];

  programs.ssh.startAgent = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
