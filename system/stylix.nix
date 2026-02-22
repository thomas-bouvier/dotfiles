{ pkgs, config, ... }:

{
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";

    fonts = {
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.nerd-fonts.dejavu-sans-mono;
      };

      serif = {
        name = "DejaVu Serif";
        package = pkgs.nerd-fonts.dejavu-sans-mono;
      };

      monospace = {
        name = "JetBrainsMono Nerd Font Mono";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      sizes = {
        applications = 9;
        desktop = 9;
        popups = 9;
        terminal = 9;
      };
    };

    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 28;
    };

    opacity.terminal = 1;
  };
}
