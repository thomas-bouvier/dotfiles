{ ... }:
{
  # The Nordic package does a better job at theming Plasma
  #stylix.targets.kde.enable = false;

  programs.plasma = {
    enable = true;

    workspace = {
      theme = "Nordic-darker";
      # plasma-apply-cursortheme --list-themes
      cursor.theme = "breeze_cursors"; # Does not work
      colorScheme = "Nordic-Darker"; # Does not work
      lookAndFeel = "Nordic-darker"; # Works (Plasma Style)
      iconTheme = "Nordic-bluish";
    };

    panels = [
      # Taskbar
      {
        height = 36;
        floating = false;
        location = "bottom";
        hiding = "none";

        widgets = [
          # Start menu
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake-white";
            };
          }
          "org.kde.plasma.pager"
          {
            name = "org.kde.plasma.digitalclock";
            config.Appearance = {
              dateFormat = "isoDate";
            };
          }
          # Taskbar icons
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [ ];
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to EurKEY (US)" = [ ];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to French" = [ ];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to French (AZERTY)" = [ ];
    };

    configFile = {
      "dolphinrc"."IconsMode"."PreviewSize" = 32;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."PreviewSettings"."Plugins" = "audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegth
  umbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 346;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."PreviewSettings"."MaximumRemoteSize" = 10485760;
      "kiorc"."Confirmations"."ConfirmDelete" = true;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "kiorc"."Confirmations"."ConfirmTrash" = false;
      "kiorc"."Executable scripts"."behaviourOnLaunch" = "alwaysAsk";
      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"."Desktops"."Number" = 2;
      "kwinrc"."Desktops"."Rows" = 1;
      "kwinrc"."Plugins"."magiclampEnabled" = true;
      "kwinrc"."Plugins"."mousemarkEnabled" = true;
      "kwinrc"."Plugins"."squashEnabled" = false;
      "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
      "kwinrc"."Xwayland"."Scale" = 1.75;
      "kxkbrc"."Layout"."LayoutList" = "eu,fr,fr";
      "kxkbrc"."Layout"."VariantList" = ",,mac";
      "plasma-localerc"."Formats"."LANG" = "en_US.utf8";
    };
  };
}
