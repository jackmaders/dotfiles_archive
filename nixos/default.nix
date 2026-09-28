{pkgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = "jackw";
  };

  programs.zsh = {
    enable = true;
    # Prevent zsh-newuser-install wizard on first login before Home Manager creates ~/.zshrc
    shellInit = ''
      zsh-newuser-install() { :; }
    '';
  };

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
