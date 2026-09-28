{pkgs, lib, ...}: {
  imports = [
    ./git.nix
    ./zsh
    ./starship
  ];

  home.stateVersion = "24.05";

  home.activation = {
      createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run mkdir -p $VERBOSE_ARG \
          $HOME/dev/personal \
          $HOME/dev/twinkl \
          $HOME/dev/sandbox \
          $HOME/dev/github.com \
          $HOME/notes
      '';
    };

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
