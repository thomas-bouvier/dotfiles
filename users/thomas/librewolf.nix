{ config, pkgs, nur, ... }:
{
  programs.librewolf = {
    enable = true;

    # Uncomment when profile support lands in home manager for librewolf.
    # https://github.com/nix-community/home-manager/pull/5128
    # https://github.com/kaldyr/nixos/blob/9cd807d250513dda5b3f449d2a79261c89e1a635/programs/librewolf.nix
    # https://github.com/donovanglover/nix-config/blob/master/home/librewolf.nix
    #profiles.default = {
    #  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #    kristofferhagen-nord-theme # I would prefer https://github.com/dragonejt/nord-firefox
    #  ];
    #};

    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.cache" = true;
      "privacy.clearOnShutdown.offlineApps" = false;
      "services.sync.prefs.sync.privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;

      "browser.tabs.loadInBackground" = true;
      "browser.toolbars.bookmarks.visibility" = "newtab";
      "browser.translations.enable" = false;

      "signon.rememberSignons" = false;
      "signon.rememberSignons.visibilityToggle" = false;
      "services.sync.prefs.sync.signon.rememberSignons" = false;
      "services.sync.prefs.sync-seen.services.sync.prefs.sync.signon.rememberSignons" = false;

      "browser.urlbar.suggest.weather" = false;
      "browser.urlbar.suggest.trending" = false;
      "browser.urlbar.suggest.yelp" = false;
      "browser.urlbar.suggest.pocket" = false;
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.history" = true;
      "browser.urlbar.suggest.mdn" = false;
      "browser.urlbar.suggest.clipboard" = false;

      "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = true;
    };
  };
}
