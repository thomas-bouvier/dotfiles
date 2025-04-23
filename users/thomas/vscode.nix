{ pkgs, ... }:
{
  # The Nordic package does a better job at theming VSCode
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.code-cursor;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        christian-kohler.path-intellisense
        ms-vscode-remote.remote-ssh
        charliermarsh.ruff

        # Vim keybindings
        vscodevim.vim

        # Nix
        jnoortheen.nix-ide

        # C++
        ms-vscode.cpptools

        # Python
        ms-python.python
        ms-python.black-formatter
        ms-toolsai.jupyter
        matangover.mypy
        bierner.github-markdown-preview
        eamodio.gitlens

        # Webdev
        vue.volar

        # Theming
        arcticicestudio.nord-visual-studio-code
        pkief.material-icon-theme
      ]
      ++ (with pkgs.open-vsx; [
        marlosirapuan.nord-deep
      ]);

      userSettings = {
        # Theming
        "workbench.colorTheme" = "Nord Deep";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
        "editor.fontSize" = 13;
      };
    };
  };
}
