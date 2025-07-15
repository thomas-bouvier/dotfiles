{ pkgs, ... }:
{
  # The Nordic package does a better job at theming VSCode
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    #package = pkgs.unstable.vscodium;

    # This patch is needed to enable GitHub Copilot Chat in VSCodium.
    # https://github.com/VSCodium/vscodium/discussions/1487
    # https://github.com/jtrrll/dotfiles/blob/main/modules/dotfiles/editors/vscode.nix
    package = pkgs.unstable.vscodium.overrideAttrs (old: {
      nativeBuildInputs =
        (old.nativeBuildInputs or [])
        ++ [
          pkgs.jq
          pkgs.uutils-coreutils-noprefix
        ];
      postInstall =
        (old.postInstall or "")
        + (let
          vscodeProductJSON = "lib/vscode/resources/app/product.json";
          vscodiumProductJSON = "lib/vscode/resources/app/product.json";
        in ''
          product_file="$out/${vscodiumProductJSON}"

          if [ -f "$product_file" ]; then
            printf "Patching product.json to enable GitHub Copilot Chat\n"

            tmp_file="$product_file.tmp"

            jq --slurpfile vscode "${pkgs.vscode}/${vscodeProductJSON}" '
              .defaultChatAgent = $vscode[0]["defaultChatAgent"]
            ' "$product_file" > "$tmp_file"

            mv "$tmp_file" "$product_file"
          else
            printf "product.json not found at %s\n" "$product_file"
          fi
        '');
    });

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        charliermarsh.ruff

        # Vim keybindings
        vscodevim.vim

        # Nix
        jnoortheen.nix-ide

        # C++
        ms-vscode.cpptools

        # Python
        ms-python.python
        ms-python.black-formatter
        ms-toolsai.jupyter
        matangover.mypy
        bierner.github-markdown-preview
        eamodio.gitlens

        # Webdev
        vue.volar

        # Theming
        pkief.material-icon-theme
      ]
      ++ (with pkgs.nix-vscode-extensions.open-vsx; [
        marlosirapuan.nord-deep
      ])
      ++ (with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
      ]);

      userSettings = {
        # Theming
        "workbench.colorTheme" = "Nord Deep";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
        "editor.fontSize" = 13;
      };
    };
  };
}
