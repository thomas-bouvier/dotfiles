{ pkgs, ... }:
{
  # The Nordic package does a better job at theming VSCode
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        ms-vscode.cpptools
      ]
      # There are incompatibilities between VSCodium and the copilot-chat
      # extension, so I bump the extension version myself.
      # https://marketplace.visualstudio.com/items/GitHub.copilot-chat/changelog
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "copilot-chat";
          publisher = "GitHub";
          version = "0.38.2";
          sha256 = "sha256-olyNllBAPQo7ZwbTQJ3GjRhSkfZ/iRv4jXM74hXjNwM=";
        }
      ]
      ++ (with pkgs.nix-vscode-extensions.open-vsx-release; [
        # IDE
        vscodevim.vim
        jeanp413.open-remote-ssh
        marlosirapuan.nord-deep
        mk12.better-git-line-blame
        bierner.markdown-preview-github-styles
        pkief.material-icon-theme

        # Python
        ms-python.python
        charliermarsh.ruff
        astral-sh.ty
        marimo-team.vscode-marimo

        # Languages
        jnoortheen.nix-ide
        vue.volar
        tsyesika.guile-scheme-enhanced
      ]);

      userSettings = {
        # Theming
        "workbench.colorTheme" = "Nord Deep";
        "workbench.iconTheme" = "material-icon-theme";
        "chat.viewSessions.orientation" = "stacked";
        "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
        "editor.fontSize" = 13;
        "explorer.confirmDelete" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "chat.disableAIFeatures" = false;
      };
    };
  };
}
