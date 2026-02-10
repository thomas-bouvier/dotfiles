{ pkgs, config, ... }:

{
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";

    # Default wallpaper for all users
    image = pkgs.fetchurl {
      url = "https://static1.squarespace.com/static/5e949a92e17d55230cd1d44f/t/666797c50267ef33983aa221/1718065110482/SequoiaDark.png";
      sha256 = "3617196d3d720cfc1d45299ff3a8461f28c03545ce65863569ae0bc4cfd57acd";
    };

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
