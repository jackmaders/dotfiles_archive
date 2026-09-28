{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.sessionVariables = {
    DOTFILES_PROFILE = "personal";
  };

  home.activation.createPersonalDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p $VERBOSE_ARG "$HOME/dev/personal"
  '';

  programs.starship.settings = builtins.fromTOML (builtins.readFile ../starship/personal.toml);

  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jackwmaders@gmail.com";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    git-lfs
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
  ];
}
