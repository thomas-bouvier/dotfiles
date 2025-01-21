{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      stylix,
      sops-nix,
      lix,
      nur,
      my-secrets,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
        };
      };
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        bolet = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };

          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ 
                  overlay-unstable
                  nur.overlays.default
                ];
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

        coprin = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };

          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ 
                  overlay-unstable
                  nur.overlays.default
                ];
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
      };
    };
}
