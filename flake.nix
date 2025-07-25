{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flox.url = "github:flox/flox";

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    nur = {
      url = "github:nix-community/nur";
    };

    my-secrets = {
      url = "git+ssh://git@github.com/thomas-bouvier/secrets.git?ref=main&shallow=1";
      flake = false;
    };

    firefox-addons = {
      url = "git+https://git.sr.ht/~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flox,
      apple-silicon,
      home-manager,
      plasma-manager,
      stylix,
      sops-nix,
      lix-module,
      lix,
      nur,
      my-secrets,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      commonOverlays = [
        nur.overlays.default
        nix-vscode-extensions.overlays.default
      ];

      mkUnstableOverlay = pkgs: (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (pkgs) system;
        };
      });
    in
    {
      nixosConfigurations.bolet = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };

        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = commonOverlays ++ [ (mkUnstableOverlay pkgs) ];
            }
          )

          flox.nixosModules.flox
          lix-module.nixosModules.default
          ./hosts/bolet/default.nix
          stylix.nixosModules.stylix

          # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit my-secrets;
              };

              sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
                inputs.sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      nixosConfigurations.coprin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };

        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = commonOverlays ++ [ (mkUnstableOverlay pkgs) ];
            }
          )

          flox.nixosModules.flox
          lix-module.nixosModules.default
          ./hosts/coprin/default.nix
          stylix.nixosModules.stylix

          # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit my-secrets;
              };

              sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
                inputs.sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      nixosConfigurations.amanite = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };

        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = commonOverlays ++ [
                (mkUnstableOverlay pkgs)
                apple-silicon.overlays.apple-silicon-overlay
              ];
            }
          )

          flox.nixosModules.flox
          apple-silicon.nixosModules.apple-silicon-support
          lix-module.nixosModules.default
          ./hosts/amanite/default.nix
          stylix.nixosModules.stylix

          # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit my-secrets;
              };

              sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
                inputs.sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    };
}
