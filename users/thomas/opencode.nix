{ lib, ... }:

{
  programs.opencode = {
    enable = true;

    tui.theme = lib.mkForce "nord";

    settings = {
      plugin = [
        "@ex-machina/opencode-anthropic-auth@1.7.5"
      ];
    };
  };
}
