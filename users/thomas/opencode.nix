{ lib, ... }:

{
  programs.opencode = {
    enable = true;

    tui.theme = lib.mkForce "nord";

    settings = {
      model = "anthropic/claude-opus-4-6";
      plugin = [
        "@ex-machina/opencode-anthropic-auth@1.7.5"
      ];
    };
  };
}
