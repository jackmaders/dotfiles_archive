{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --git --icons";
      la = "eza -la --git --icons";
      tree = "eza --tree --icons";
      cat = "bat -p";
      grep = "rg";
      find = "fd";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    initContent = ''
      # Allow inline comments when pasting scripts/commands
      setopt interactivecomments

      # Case-insensitive tab completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      
      # Bind up/down arrows to history substring search
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
