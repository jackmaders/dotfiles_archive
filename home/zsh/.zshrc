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
  local target="$HOME/dev/dotfiles"
  if [ ! -d "$target" ] && [ ! -d "$HOME/dotfiles" ]; then
    echo "==> Cloning dotfiles to $target..."
    mkdir -p "$HOME/dev"
    git clone https://github.com/jackmaders/dotfiles.git "$target"
  fi

  if [ -d "$target" ]; then
    echo "$target"
  elif [ -d "$HOME/dotfiles" ]; then
    echo "$HOME/dotfiles"
  else
    echo "$target"
  fi
}

# Apply current local config and home manager state (run from repo root or anywhere)
nixos-apply-local() {
  local dir
  # If currently inside a repo with a flake.nix, use current directory; otherwise use standard dotfiles dir
  if [ -f "./flake.nix" ]; then
    dir="."
  else
    dir="$(_dotfiles_dir)"
  fi

  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "==> Applying local NixOS system configuration..."
  sudo nixos-rebuild switch --flake "$dir#nixos" && \
  echo "==> Applying local Home Manager configuration ($profile)..." && \
  if command -v home-manager >/dev/null 2>&1; then
    home-manager switch --flake "$dir#$profile"
  else
    nix run github:nix-community/home-manager -- switch --flake "$dir#$profile"
  fi
}

# Fetch and apply the latest config and home manager state available in git
nixos-apply-remote() {
  local dir="$(_dotfiles_dir)"
  local profile="${1:-${DOTFILES_PROFILE:-personal}}"
  echo "==> Fetching latest changes from Git..."
  git -C "$dir" pull && nixos-apply-local "$profile"
}

# Local Secrets File
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
