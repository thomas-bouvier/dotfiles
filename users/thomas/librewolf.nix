{ config, pkgs, ... }:
{
  programs.librewolf = {
    enable = true;

    settings = {
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearOnShutdown.offlineApps" = false;

      "browser.toolbars.bookmarks.visibility" = "newtab";
      "browser.translations.enable" = false;
      "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
    };
  };
}
