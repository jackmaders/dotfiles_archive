{
  pkgs,
  inputs,
  ...
}: {
  home.sessionVariables = {
    DOTFILES_PROFILE = "personal";
  };

  programs.starship.settings = builtins.fromTOML (builtins.readFile ../starship/personal.toml);

  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jackwmaders@gmail.com";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
  ];
}
