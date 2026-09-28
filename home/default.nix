{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./zsh.nix
  ];

  home.stateVersion = "24.05"; # Match your installed NixOS/HM version

  # Core Rust-based userland replacements
  home.packages = with pkgs; [
    # Core utilities
    ripgrep   # rg -> modern grep
    fd        # modern find
    dust      # du -> visual disk usage
    xh        # curl/httpie replacement
    just      # make replacement
    delta     # git diff pager

    # Navigation & file viewing
    eza       # ls replacement
    bat       # cat replacement
    zoxide    # smart cd
  ];

  # Basic program hooks without custom styling
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;
}
