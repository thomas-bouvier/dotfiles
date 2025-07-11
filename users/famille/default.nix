{ config, pkgs, my-secrets, ... }:

{
  imports = [
    ./librewolf.nix
    ./plasma.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "famille";
  home.homeDirectory = "/home/famille";

  home.language = {
    base = "fr_FR.utf8";
  };

  # Stylix configuration for user-specific wallpaper
  stylix = {
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/thomas-bouvier/wallpapers/main/20190721_122217.jpg";
      sha256 = "sha256-8VYuc3CP4gnuwTvogvIK6qvi4R+xtIpbb41RLsK53gA=";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Everyday life
    localsend
    vlc
    kdePackages.kcharselect
    kdePackages.kfind
    kdePackages.filelight
    kdePackages.kompare
    libreoffice-qt6-fresh

    # Theme
    nordic
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thomas/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
