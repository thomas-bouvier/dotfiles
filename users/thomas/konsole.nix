{ config, pkgs, nur, ... }:
let
  nord-konsole-theme = pkgs.fetchFromGitHub {
    repo = "konsole";
    owner = "nordtheme";
    rev = "c196f011908c1e10a5b15d516856ab5a47e85c5e";
    hash = "sha256-qmWpj65oTRBnREx5EJ0Qc2TS28GHb3Uv9Kq68O2AHw4=";
  };
in
{
  programs.konsole = {
    enable = true;

    defaultProfile = "Profile 1";
    customColorSchemes.nord = "${nord-konsole-theme}/src/nord.colorscheme";
    profiles = {
      "Profile 1" = {
        colorScheme = "nord";
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 10;
        };
      };
    };

    extraConfig = {
      Default.MenuBar = "Disabled";
      # Hide toolbars
      MainWindow.State = "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAvsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAARUBAAAD+wAAACIAUQB1AGkAYwBrAEMAbwBtAG0AYQBuAGQAcwBEAG8AYwBrAAAAAAD/////AAABfAEAAAMAAAVWAAACqAAAAAQAAAAEAAAACAAAAAj8AAAAAQAAAAIAAAACAAAAFgBtAGEAaQBuAFQAbwBvAGwAQgBhAHIAAAAAAP////8AAAAAAAAAAAAAABwAcwBlAHMAcwBpAG8AbgBUAG8AbwBsAGIAYQByAAAAAAD/////AAAAAAAAAAA=";
    };
  };
}
