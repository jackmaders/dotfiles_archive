{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./git.nix
    ./zsh
    ./starship
  ];

  home.stateVersion = "24.05";

  home.activation = {
    createSharedDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p $VERBOSE_ARG \
        $HOME/dev/sandbox \
        $HOME/dev/github.com \
        $HOME/vaults
    '';

    installHerdr = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -x "$HOME/.local/bin/herdr" ]; then
        run mkdir -p "$HOME/.local/bin"
        run ${pkgs.curl}/bin/curl -fsSL https://herdr.dev/install.sh | \
          run ${pkgs.coreutils}/bin/env \
            PATH="${pkgs.curl}/bin:${pkgs.gawk}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:$PATH" \
            ${pkgs.bash}/bin/bash
      fi
    '';
  };

  home.packages = with pkgs; [
    bun
    dust
    fnm
    just
    obsidian
    pnpm
    xh
    vim
    vimgolf
  ];

  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* ]] && [ -z "$ZSH_VERSION" ] && [ -x "${pkgs.zsh}/bin/zsh" ]; then
        exec ${pkgs.zsh}/bin/zsh
      fi
    '';
  };

  home.sessionVariables = {
    BUN_INSTALL = "$HOME/.bun";
    PNPM_HOME = "$HOME/.local/share/pnpm";
    LIBGL_ALWAYS_SOFTWARE = "1";
    DISPLAY = ":0";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.local/share/pnpm"
  ];
}
