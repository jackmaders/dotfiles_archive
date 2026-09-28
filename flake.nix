{
  description = "Dotfiles and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    mkHome = {
      profileModule,
      username ? "jackw",
    }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
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
