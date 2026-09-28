{pkgs, ...}: {
  home.sessionVariables = {
    DOTFILES_PROFILE = "twinkl";
  };

  programs.starship.settings = builtins.fromTOML (builtins.readFile ../starship/pure.toml);

  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jack.maders@twinkl.co.uk";
  };

  home.packages = with pkgs; [
    aws-vault
  ];
}
