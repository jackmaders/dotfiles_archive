# Allow comments in shell sessions
setopt interactivecomments

# Ctrl + Left / Ctrl + Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Fast Node Manager
eval "$(fnm env --use-on-cd)"

# Local Secrets File
[ -f ~/.zsh_local ] && source ~/.zsh_local
