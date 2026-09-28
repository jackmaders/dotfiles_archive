{pkgs, ...}: {
  home.sessionVariables = {
    DOTFILES_PROFILE = "twinkl";
  };

  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jack.maders@twinkl.co.uk";
  };

  home.packages = with pkgs; [
    aws-vault
  ];
}
