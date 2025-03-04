{ config, pkgs, nur, ... }:
{
  programs.librewolf = {
    enable = true;

    profiles.default.extensions = {
      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        kristofferhagen-nord-theme # I would prefer https://github.com/dragonejt/nord-firefox
      ];
    };

    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.dowloads" = true;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.cache" = true;
      "privacy.clearOnShutdown.offlineApps" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
      "privacy.resistFingerprinting" = false;

      "identity.fxaccounts.enabled" = true;

      "browser.tabs.loadInBackground" = true;
      "browser.toolbars.bookmarks.visibility" = "newtab";

      "signon.rememberSignons" = false;
      "signon.rememberSignons.visibilityToggle" = false;

      "services.sync.prefs.sync.privacy.clearOnShutdown.history" = false;
      "services.sync.prefs.sync.signon.rememberSignons" = false;
      "services.sync.prefs.sync-seen.services.sync.prefs.sync.signon.rememberSignons" = false;

      "browser.translations.enable" = false;
      "browser.tabs.tabmanager.enabled" = false;
      "browser.firefox-view.virtual-list.enabled" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.bookmark" = true;
      "browser.urlbar.suggest.weather" = false;
      "browser.urlbar.suggest.trending" = false;
      "browser.urlbar.suggest.yelp" = false;
      "browser.urlbar.suggest.pocket" = false;
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.mdn" = false;
      "browser.urlbar.suggest.clipboard" = false;

      "extensions.pocket.enabled" = false;

      "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = true;

      "webgl.disabled" = false;
    };
  };
}
