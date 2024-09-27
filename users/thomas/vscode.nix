{ pkgs, ... }:
{
  # The Nordic package does a better job at theming VSCode
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;

    extensions = with pkgs.unstable.vscode-extensions; [
      # Vim keybindings
      vscodevim.vim
    
      # Theming
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
    ];

    userSettings = {
      # Theming
      "workbench.colorTheme" = "Nord";
      "workbench.iconTheme" = "material-icon-theme";
    };
  };
}
