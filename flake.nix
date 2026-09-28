{
  description = "Dotfiles and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity.url = "github:Hy4ri/antigravity-flake";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    mkHome = {
      profileModule,
      username ? "jackw",
    }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/default.nix
          profileModule
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }
        ];
      };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-wsl.nixosModules.default
          ./nixos/default.nix
        ];
      };
    };

    homeConfigurations = {
      personal = mkHome {
        profileModule = ./home/profiles/personal.nix;
      };

      twinkl = mkHome {
        profileModule = ./home/profiles/twinkl.nix;
      };
    };
  };
}
