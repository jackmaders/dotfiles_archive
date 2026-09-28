{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Smart, clean history settings
    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    # Essential aliases mapped to our fast Rust utilities
    shellAliases = {
      # ls -> eza
      ls = "eza";
      ll = "eza -l --git";
      la = "eza -la --git";
      tree = "eza --tree";

      # cat -> bat (plain mode by default to avoid interfering with raw outputs)
      cat = "bat -p";

      # grep/find upgrades
      grep = "rg";
      find = "fd";

      # Navigation shortcuts
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    # Case-insensitive tab completion & substring navigation
    initExtra = ''
      # Case-insensitive tab completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      
      # Bind up/down arrows to history substring search
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
    '';
  };

  # FZF integration for shell navigation and reverse history search
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable zoxide integration for Zsh (replaces 'cd' with 'z')
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
