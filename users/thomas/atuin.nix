{ config, pkgs, secretsPath, ... }:
{
  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;

    settings = {
      # Uncomment this to use your instance
      # sync_address = "https://majiy00-shell.fly.dev";

      sync.records = true;
      auto_sync = true;
      sync_frequency = "5m";
      key_path = config.sops.secrets.atuin_key.path;
    };
  };

  sops.secrets.atuin_key = {
    sopsFile = "${secretsPath}/secrets/atuin.sops.yaml";
  };
}
