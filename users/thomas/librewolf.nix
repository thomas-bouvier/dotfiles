{ config, pkgs, nur, ... }:

{
  programs.librewolf = {
    enable = true;

    profiles.default = {
      isDefault = true;

      search = {
        engines = {
          "Kagi" = {
            urls = [{
              template = "https://kagi.com/search";
              params = [ { name = "q"; value = "{searchTerms}"; } ];
            }];
            icon = "https://assets.kagi.com/v1/kagi_assets/logos/yellow_3.svg";
            updateInterval = 24 * 60 * 60 * 1000; # Daily
            definedAliases = [ "@kagi" ];
          };

          "GitHub" = {
            urls = [{
              template =
                "https://github.com/search?q={searchTerms}&type=repositories";
            }];
            definedAliases = [ "!gh" ];
          };

          "YouTube" = {
            urls = [{
              template =
                "https://www.youtube.com/results?search_query={searchTerms}";
            }];
            definedAliases = [ "!y" ];
          };
        };
        default = "Kagi";
        privateDefault = "Kagi";
      };
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

      "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
      "browser.newtabpage.activity-stream.showSearch" = true;
      "browser.newtabpage.activity-stream.showShortcuts" = false;
      "browser.newtabpage.activity-stream.shortcuts.enabled" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.feeds.section.topsites" = false;
      "browser.newtabpage.activity-stream.feeds.system.topsites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
      "browser.newtabpage.activity-stream.feeds.system.highlights" = true;
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
      "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = true;
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      "browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;

      # Use native file picker instead of GTK file picker
      "widget.use-xdg-desktop-portal.file-picker" = 1;

      "webgl.disabled" = false;

      # Activate HTTPS-Only Mode in all windows
      # Forces secure HTTPS connections for all sites
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_ever_enabled" = true;

      # DNS over HTTPS (DoH) with NextDNS
      # Mode 3 = DoH only, no fallback to traditional DNS
      "network.trr.mode" = 3;
      "network.trr.custom_uri" = "https://dns0.eu";
      "network.trr.uri" = "https://dns0.eu";
      "network.trr.confirmationNS" = "skip";
      "network.dns.skipTRR-when-parental-control-enabled" = false;

      # Enable HTTP/3 (QUIC) for better performance and security
      "network.http.http3.enabled" = true;

      # Always ask where to download
      "browser.download.useDownloadDir" = false;
    };
  };
}
