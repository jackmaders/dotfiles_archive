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

  home.sessionVariables = {
    BUN_INSTALL = "$HOME/.bun";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.local/share/pnpm"
  ];
}
