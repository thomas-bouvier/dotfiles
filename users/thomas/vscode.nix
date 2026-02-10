{ pkgs, ... }:
{
  # The Nordic package does a better job at theming VSCode
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.unstable.vscodium;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        ms-vscode.cpptools
        github.copilot-chat
      ]
      ++ (with pkgs.nix-vscode-extensions.open-vsx-release; [
        # IDE
        vscodevim.vim
        ms-vscode-remote.remote-ssh
        marlosirapuan.nord-deep
        mk12.better-git-line-blame
        bierner.markdown-preview-github-styles
        pkief.material-icon-theme

        # Python
        ms-python.python
        charliermarsh.ruff
        matangover.mypy
        marimo-team.vscode-marimo

        # Languages
        jnoortheen.nix-ide
        vue.volar
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
