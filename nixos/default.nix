{pkgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = "jackw";
    # Use the WSLg GPU driver libraries exposed by the Windows host.
    useWindowsDriver = true;
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

  # NixOS-WSL supplies WSLg's DISPLAY, WAYLAND_DISPLAY and XDG_RUNTIME_DIR.
  # Leave them untouched so the host-provided GUI session remains available.
  hardware.graphics.enable = true;

  # Keep the .NET runtime discoverable by Godot and C# tooling.
  environment.variables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}/share/dotnet";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  programs.git.lfs.enable = true;

  # Allow running unpatched dynamically linked executables (npx, fnm downloaded node, vscode servers, etc.)
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    dotnet-sdk_8
    godot_4-mono
    netcoredbg
    csharp-ls
    git
    git-lfs
    mesa
    vulkan-loader
    vulkan-tools
    mesa-demos # glxinfo
    pciutils
    curl
    wget
    vim
  ];

  system.stateVersion = "24.05";
}
