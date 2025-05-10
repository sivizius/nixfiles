{ pkgs, ... }:
{
  AppAutoUpdate = false;
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;

  BackgroundAppUpdate = false;
  BlockAboutAddons = true;
  BlockAboutConfig = true;
  BlockAboutProfiles = true;

  CaptivePortal = false;

  DisableAppUpdate = true;
  DisableFirefoxAccounts = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableSetDesktopBackground = true;
  DisableTelemetry = true;
  DNSOverHTTPS = {
    Enabled = true;
    Fallback = true;
    Locked = true;
    ProviderURL = "https://dns.quad9.net/dns-query";
  };
  DontCheckDefaultBrowser = true;
  DownloadDirectory = "/home/sivizius/Downloads/librewolf";

  EnableTrackingProtection = {
    Cryptomining = true;
    Fingerprinting = true;
    EmailTracking = true;
    Locked = true;
    Value = true;
  };

  FirefoxHome = {
    Locked = true;
    Pocket = false;
    Search = true;
    Snippets = false;
    SponsoredPocket = false;
    SponsoredTopSites = false;
  };

  HardwareAcceleration = true;
  Homepage = {
    Locked = true;
    StartPage = "previous-session";
  };
  HttpsOnlyMode = "enabled";

  NewTabPage = true;
  NoDefaultBookmarks = true;

  OfferToSaveLogins = false;

  PasswordManagerEnabled = false;
  PostQuantumKeyAgreementEnabled = true;
  Preferences = {
    "browser.uiCustomization.state" = builtins.toJSON {
      placements = {
        nav-bar = [
          #"treestyletab_piro_sakura_ne_jp-browser-action"
          "back-button"
          "forward-button"
          "stop-reload-button"

          "urlbar-container"

          "zoom-controls"
          "screenshot-button"
          "developer-button"
          "downloads-button"

          "unified-extensions-button"
          "ublock0_raymondhill_net-browser-action"
          "sponsorblocker_ajay_app-browser-action"
          "passff_invicem_pro-browser-action"
          "addon_darkreader_org-browser-action"
        ];
      };
    };
  };

  SanitizeOnShutdown = {
    Locked = true;
  };
  SearchBar = "unified";
  SearchEngines = import ./search-engines.nix;
  SearchSuggestEnabled = true;
  SecurityDevices = {
    Add = {
      # Use a proxy module rather than `nixpkgs.config.firefox.smartcardSupport = true`
      "PKCS#11 Proxy Module" = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
    };
  };
  SSLVersionMin = "tls1.2";
  StartDownloadsInTempDirectory = true;

  TranslateEnabled = true;

  UserMessaging = {
    ExtensionRecommendations = false;
    FeatureRecommendations = false;
    FirefoxLabs = false;
    Locked = true;
    MoreFromMozilla = false;
    SkipOnboarding = true;
  };
}
