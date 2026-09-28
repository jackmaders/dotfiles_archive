{pkgs, ...}: {
  imports = [
    ./git.nix
    ./zsh
    ./starship
  ];

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    bun
    dust
    fnm
    just
    pnpm
    xh
  ];

  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
}
