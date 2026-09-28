{pkgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = "jackw";
  };

  programs.zsh.enable = true;

  users.users.jackw = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
  ];

  system.stateVersion = "24.05";
}
