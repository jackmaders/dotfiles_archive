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

# Rebuild and activate Home Manager configuration
rebuild-home() {
  local dir="$(_dotfiles_dir)"
  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "==> Rebuilding Home Manager ($profile)..."
  if command -v home-manager >/dev/null 2>&1; then
    home-manager switch --flake "$dir#$profile"
  else
    nix run github:nix-community/home-manager -- switch --flake "$dir#$profile"
  fi
}

# Rebuild and activate NixOS system configuration
rebuild-system() {
  local dir="$(_dotfiles_dir)"
  echo "==> Rebuilding NixOS system..."
  sudo nixos-rebuild switch --flake "$dir#nixos"
}

# Refresh both NixOS system and Home Manager configuration
refresh-config() {
  local dir="$(_dotfiles_dir)"
  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "==> Refreshing NixOS system & Home Manager ($profile)..."
  rebuild-system && rebuild-home "$profile"
}

# Pull latest dotfiles and refresh both NixOS and Home Manager
update-config() {
  local dir="$(_dotfiles_dir)"
  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "==> Pulling latest changes from Git..."
  git -C "$dir" pull && refresh-config "$profile"
}

# Local Secrets File
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
