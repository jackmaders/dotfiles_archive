{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    # Replace these with your details:
    userName = "Jack Maders";
    userEmail = "jackwmaders@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
