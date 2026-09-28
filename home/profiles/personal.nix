{ pkgs, ... }:

{
  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jackwmaders@gmail.com";
  };

  home.packages = with pkgs; [
    # Any personal-only tools
  ];
}
