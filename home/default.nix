{pkgs, ...}: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./starship.nix
  ];

  home.stateVersion = "24.05";

  # Core Rust-based userland replacements
  home.packages = with pkgs; [
    ripgrep
    fd
    dust
    xh
    just
    delta
    eza
    bat
    zoxide
    bun
    fnm
    pnpm
  ];

  # Basic program hooks
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;
}
