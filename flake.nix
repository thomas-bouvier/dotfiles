{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
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
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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
      apple-silicon,
      home-manager,
      plasma-manager,
      stylix,
      sops-nix,
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

          lix.nixosModules.default
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

          lix.nixosModules.default
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

          apple-silicon.nixosModules.apple-silicon-support
          lix.nixosModules.default
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
