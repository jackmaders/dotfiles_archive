# Allow comments in shell sessions
setopt interactivecomments

# Ctrl + Left / Ctrl + Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Filter history
bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward

# Prevent multi line suggestions
ZSH_AUTOSUGGEST_HISTORY_IGNORE="*$'\n'*"

# Fast Node Manager
eval "$(fnm env --use-on-cd --shell zsh)"

# Local Secrets File
[ -f ~/.zsh_local ] && source ~/.zsh_local
