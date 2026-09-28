{pkgs, ...}: {
  home.sessionVariables = {
    DOTFILES_PROFILE = "twinkl";
  };

  programs.starship.settings = builtins.fromTOML (builtins.readFile ../starship/twinkl.toml);

  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jack.maders@twinkl.co.uk";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    aws-vault
    claude-code
  ];
}
