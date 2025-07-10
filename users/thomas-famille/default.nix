{ config, pkgs, my-secrets, ... }:

let
  secretsPath = builtins.toString my-secrets;
in
{
  imports = [
    (import ../thomas/atuin.nix { inherit config pkgs; secretsPath = secretsPath; })
    ../thomas/konsole.nix
    ../thomas/librewolf.nix
    ../thomas/plasma.nix
    ../thomas/ssh.nix
    ../thomas/tmux.nix
    ../thomas/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

  # Configure sops location
  # https://github.com/Mic92/sops-nix?tab=readme-ov-file#use-with-home-manager
  sops = {
    defaultSopsFile = "${secretsPath}/secrets/secrets.sops.yaml";
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "/home/thomas/.config/sops/age/keys.txt";
    };
  };

  # Stylix configuration for user-specific wallpaper
  stylix = {
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/thomas-bouvier/wallpapers/main/mont-saint-michel.jpg";
      sha256 = "sha256-IVcBW3Cd2TMyvGPtB88pyLeeNFt1jkxGWssQ9yuhFdQ=";
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
    kdePackages.partitionmanager
    libreoffice-qt6-fresh

    # Command line
    neovim
    eza
    age
    htop
    sops
    docker
    docker-compose
    jq
    unrar

    # Theme
    nordic
    (whitesur-icon-theme.override {
      alternativeIcons = true;
      boldPanelIcons = true;
    })

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (writeShellScriptBin "g5k" (builtins.readFile ../thomas/assets/g5k))
    (writeShellScriptBin "ide" (builtins.readFile ../thomas/assets/ide))
  ];

  programs.git = {
    enable = true;
    userName = "Thomas Bouvier";
    userEmail = "contact@thomas-bouvier.io";

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

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
