{ config, lib, secretsPath, ... }:

{
  programs.opencode = {
    enable = true;

    tui.theme = lib.mkForce "nord";

    settings = {
      model = "Cursor GLM 5.2";

      provider = {
        scaleway = {
          options = {
            apiKey = "{file:${config.sops.secrets.scaleway_key.path}}";
            baseURL = "https://api.scaleway.ai/v1";
          };

          models = {
            qwen36 = {
              name = "qwen3.6-35b-a3b";
            };
          };
        };

        cursor-acp = {
          name = "Cursor ACP";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://127.0.0.1:32124/v1";
          };
          models = {
            "cursor-acp/auto" = {
              name = "Auto";
            };
            "cursor-acp/glm-5.2-high" = {
              name = "Cursor GLM 5.2";
            };
          };
        };
      };

      plugin = [
        "@ex-machina/opencode-anthropic-auth@1.7.5"
        "@rama_nigg/open-cursor@latest"
      ];
    };
  };

  xdg.configFile = {
    # Global instructions opencode injects into every session's system prompt.
    "opencode/AGENTS.md".text = ''
      # Global instructions

      - Never post or reply to comments on GitHub on my behalf. This includes
      PR/issue comments, review comments and their replies, and reviews —
      whether via `gh`, the GitHub REST/GraphQL API, or any MCP/tool. PR and
      issue bodies are fine. Reading GitHub is fine. If a comment/reply
      genuinely seems needed, draft the text and let me post it myself.

      - Never commit code on my behalf.

      - Say "I don't know" if you don't know. Ask questions if some
      clarification is needed.

      - Stick to the following principles: readability first. Small functions.
      Single responsibility. Keep changes minimal, implement only what's
      necessary.

      - Try to reuse existing functions if possible. Do not blindly copy/paste
      code sections without thinking about the broader context at the new
      location. Always take some perspective.

      - Do not remove existing comments. Comments are useful for humans. Do
      not hesitate to write additional comments to explain tricky sections.

      - No fallbacks by default. Add them only if explicitly requested or
        strictly required.

      - When implementing a new feature, do not keep legacy codepaths unless
      asked explicitly. Also, don't comment on the fact that the code has
      changed.

      - When writing docs or READMEs, do not write the complete and detailed
      project directory tree, unless it really makes sense for some reason.
      This is often redundant information.
    '';
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

  sops.secrets.scaleway_key = {
    sopsFile = "${secretsPath}/secrets/scaleway.sops.yaml";
  };
}
