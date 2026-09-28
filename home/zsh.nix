{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

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
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";

      ls = "eza --icons --group-directories-first";
      ll = "eza -l --git --icons --group-directories-first";
      la = "eza -la --git --icons --group-directories-first";
      tree = "eza --tree --icons";

      cat = "bat -p";
      grep = "rg";
      find = "fd";
    };

    initContent = ''
      setopt interactivecomments
      setopt incappendhistory

      # --- Paste Performance Fixes ---
      # 1. Do not compute autosuggestions for long pasted buffers
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

      # 2. Prevent syntax highlighter from lagging on multi-line bracketed pastes
      pasteinit() {
        OLD_ZSH_HIGHLIGHT_HIGHLIGHTERS=("''${ZSH_HIGHLIGHT_HIGHLIGHTERS[@]}")
        ZSH_HIGHLIGHT_HIGHLIGHTERS=()
      }
      pastefinish() {
        ZSH_HIGHLIGHT_HIGHLIGHTERS=("''${OLD_ZSH_HIGHLIGHT_HIGHLIGHTERS[@]}")
      }
      zstyle :bracketed-paste-magic paste-init pasteinit
      zstyle :bracketed-paste-magic paste-finish pastefinish

      # Case-insensitive tab completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Beginning substring search
      autoload -U up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[OA' up-line-or-beginning-search
      bindkey '^[OB' down-line-or-beginning-search

      # Word navigation (Ctrl + Left / Ctrl + Right)
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word

      # Autosuggestion controls
      bindkey '^ ' autosuggest-accept
      bindkey '^F' vi-forward-word

      # Local untracked secrets and machine-local hooks
      [ -f ~/.zsh_secrets ] && source ~/.zsh_secrets
      [ -f ~/.zsh_local ] && source ~/.zsh_local
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
