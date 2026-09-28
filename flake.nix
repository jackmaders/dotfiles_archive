{
  description = "Jack's Dotfiles and Home Manager Flake";

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
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    mkHome = profileModule:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/default.nix
          profileModule
          {
            home.username = "jackw";
            home.homeDirectory = "/home/jackw";
          }
        ];
      };
  in {
    formatter.${system} = pkgs.writeShellScriptBin "alejandra" ''
      if [ "$#" -eq 0 ]; then
        exec ${pkgs.alejandra}/bin/alejandra .
      else
        exec ${pkgs.alejandra}/bin/alejandra "$@"
      fi
    '';
    homeConfigurations = {
      "jackw-personal" = mkHome ./home/profiles/personal.nix;
      "jackw-work" = mkHome ./home/profiles/work.nix;
    };
  };
}
