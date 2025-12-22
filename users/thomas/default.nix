{ config, pkgs, my-secrets, ... }:

let
  secretsPath = builtins.toString my-secrets;
in
{
  imports = [
    (import ./atuin.nix { inherit config pkgs; secretsPath = secretsPath; })
    ./konsole.nix
    ./librewolf.nix
    ./plasma.nix
    ./ssh.nix
    ./tmux.nix
    ./vscode.nix
    ./zsh.nix
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
      url = "https://raw.githubusercontent.com/thomas-bouvier/wallpapers/main/ecmwf.png";
      sha256 = "sha256-m9DzW+B5As/FemMObk2Kll+Nf2B3uYaHD8EXJl0w+pU=";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Everyday life
    anki
    thunderbird
    obsidian
    localsend
    vlc
    signal-desktop-bin
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
    nix-output-monitor
    unrar
    nh

    # Development
    python312
    mypy
    uv
    go
    hugo
    marimo
    cudaPackages.nsight_systems

    # Android
    android-tools

    # Research
    texliveFull
    texstudio

    # Graphics
    inkscape
    kdePackages.kdenlive

    # Entertainment
    ryubing
    luanti
    nicotine-plus
    gpodder
    mixxx

    # Audio
    kdePackages.elisa
    yt-dlp
    audacity
    ffmpeg

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
    (writeShellScriptBin "g5k" (builtins.readFile ./assets/g5k))
    (writeShellScriptBin "ide" (builtins.readFile ./assets/ide))
  ]
  ++ (if stdenv.hostPlatform.system != "aarch64-linux" then [
    zotero
  ] else [ ]);

  programs.git = {
    enable = true;

    settings = {
      user.name = "Thomas Bouvier";
      user.email = "contact@thomas-bouvier.io";

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
