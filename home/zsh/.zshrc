# Allow comments in shell sessions
setopt interactivecomments

# Ctrl + Left / Ctrl + Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Filter history
bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward

# Fast Node Manager
eval "$(fnm env --use-on-cd --shell zsh)"

# Helper function to find dotfiles repo location
_dotfiles_dir() {
  if [ -d "$HOME/dev/dotfiles" ]; then
    echo "$HOME/dev/dotfiles"
  elif [ -d "$HOME/dotfiles" ]; then
    echo "$HOME/dotfiles"
  else
    echo "$HOME/dev/dotfiles"
  fi
}

# Switch Home Manager configuration (auto-detects personal vs twinkl from $DOTFILES_PROFILE)
hms() {
  local dir="$(_dotfiles_dir)"
  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "Switching Home Manager ($profile)..."
  if command -v home-manager >/dev/null 2>&1; then
    home-manager switch --flake "$dir#$profile"
  else
    nix run github:nix-community/home-manager -- switch --flake "$dir#$profile"
  fi
}

# Pull latest dotfiles and switch Home Manager
hmu() {
  local dir="$(_dotfiles_dir)"
  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "Pulling latest dotfiles..."
  git -C "$dir" pull && hms "$profile"
}

# Rebuild NixOS system configuration
nrs() {
  local dir="$(_dotfiles_dir)"
  echo "Rebuilding NixOS system..."
  sudo nixos-rebuild switch --flake "$dir#nixos"
}

# Pull latest dotfiles and rebuild NixOS system
nru() {
  local dir="$(_dotfiles_dir)"
  echo "Pulling latest dotfiles..."
  git -C "$dir" pull && nrs
}

# Local Secrets File
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
