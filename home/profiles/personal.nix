{pkgs, inputs, ...}: {
  programs.git.settings.user = {
    name = "Jack Maders";
    email = "jackwmaders@gmail.com";
  };

  home.packages = with pkgs; [
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli  ];
}
