{
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    DOTFILES_PROFILE = "twinkl";
  };

  home.activation.createTwinklDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p $VERBOSE_ARG "$HOME/dev/twinkl"
  '';

  programs.starship.settings = builtins.fromTOML (builtins.readFile ../starship/twinkl.toml);

  programs.git.settings = {
    user = {
      name = "Jack Maders";
      email = "jack.maders@twinkl.co.uk";
      signingKey = "~/.ssh/id_ed25519.pub";
    };
    commit.gpgsign = true;
    gpg.format = "ssh";
    tag.gpgsign = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    aws-vault
    claude-code
  ];
}
