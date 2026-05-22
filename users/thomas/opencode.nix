{ lib, ... }:

{
  programs.opencode = {
    enable = true;

    tui.theme = lib.mkForce "nord";

    settings = {
      model = "qwen3.6-35b-a3b";

      provider = {
        scaleway = {
          options = {
            apiKey = "{env:SCW_SECRET_KEY}";
            baseURL = "https://api.scaleway.ai/v1";
          };

          models = {
            qwen36 = {
              name = "qwen3.6-35b-a3b";
            };
          };
        };
      };

      plugin = [
        "@ex-machina/opencode-anthropic-auth@1.7.5"
      ];
    };
  };

  systemd.user.services.opencode-serve = {
    Unit = {
      Description = "OpenCode headless server";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "/etc/profiles/per-user/thomas/bin/opencode serve --port 4096 --hostname 127.0.0.1";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
