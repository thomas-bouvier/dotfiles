{
  config,
  pkgs,
  nur,
  ...
}:
{
  programs.konsole = {
    enable = true;

    defaultProfile = "Profile 1";
    customColorSchemes.nord = {
      Background.Color = "46,52,64";
      BackgroundIntense.Color = "46,52,64";
      Foreground.Color = "216,222,233";
      ForegroundIntense = {
        Color = "216,222,233";
        Bold = true;
      };
      Color0.Color = "59,66,82";
      Color0Intense.Color = "76,86,106";
      Color1.Color = "191,97,106";
      Color1Intense.Color = "191,97,106";
      Color2.Color = "163,190,140";
      Color2Intense.Color = "163,190,140";
      Color3.Color = "235,203,139";
      Color3Intense.Color = "235,203,139";
      Color4.Color = "129,161,193";
      Color4Intense.Color = "129,161,193";
      Color5.Color = "180,142,173";
      Color5Intense.Color = "180,142,173";
      Color6.Color = "136,192,208";
      Color6Intense.Color = "143,188,187";
      Color7.Color = "229,233,240";
      Color7Intense.Color = "236,239,244";
      General = {
        Description = "Nord";
        Opacity = 1;
        Wallpaper = "";
      };
    };
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
