# Dotfiles & NixOS-WSL Configuration

Declarative system and user environment managed with [Nix Flakes](https://nixos.wiki/wiki/Flakes), [NixOS-WSL](https://github.com/nix-community/NixOS-WSL), and [Home Manager](https://github.com/nix-community/home-manager).

---

## Structure

```
.
├── flake.nix                   # Flake inputs and outputs (system & home configs)
├── flake.lock                  # Pinned dependencies
├── nixos/                      # NixOS system-level configuration
│   └── default.nix             # WSL integration, default user (jackw), Zsh, sudo
└── home/                       # Home Manager user-level configuration
    ├── default.nix             # Core packages, directories, environment, bash-to-zsh guard
    ├── git.nix                 # Git configuration
    ├── profiles/
    │   ├── personal.nix        # Personal profile (Git credentials, personal packages)
    │   └── twinkl.nix          # Work profile (Twinkl Git credentials, work packages)
    ├── starship/               # Starship prompt configuration
    └── zsh/                    # Zsh plugins, aliases, history, and completions
```

---

Run the respective block directly in **Windows PowerShell** to fully provision the machine from zero (provisions system, creates `jackw`, configures default user/Zsh, applies Home Manager, and launches the shell):

### Twinkl (`NixOS_Twinkl`)

```powershell
# 1. Provision NixOS system, create 'jackw', enable Zsh, configure WSL
wsl -d NixOS_Twinkl -u root -- nixos-rebuild switch --flake "github:jackmaders/dotfiles#nixos"

# 2. Restart WSL to activate 'jackw' as default user
wsl --shutdown

# 3. Provision Twinkl Home Manager profile
wsl -d NixOS_Twinkl -u jackw -- nix run github:nix-community/home-manager -- switch --flake "github:jackmaders/dotfiles#twinkl"

# 4. Launch your fresh environment
wsl -d NixOS_Twinkl
```

---

### Personal (`NixOS_Personal`)

```powershell
# 1. Provision NixOS system, create 'jackw', enable Zsh, configure WSL
wsl -d NixOS_Personal -u root -- nixos-rebuild switch --flake "github:jackmaders/dotfiles#nixos"

# 2. Restart WSL to activate 'jackw' as default user
wsl --shutdown

# 3. Provision Personal Home Manager profile
wsl -d NixOS_Personal -u jackw -- nix run github:nix-community/home-manager -- switch --flake "github:jackmaders/dotfiles#personal"

# 4. Launch your fresh environment
wsl -d NixOS_Personal
```

---

## Commands

| Command | Action | Description |
|---|---|---|
| **`nixos-apply-local [profile]`** | Apply Local State | Applies the current local config and Home Manager state. Useful for testing changes locally without syncing to Git. Defaults to current profile (`personal` or `twinkl`). |
| **`nixos-apply-remote [profile]`** | Fetch & Apply Remote | Fetches (`git pull`) and applies the current config and Home Manager state available in Git. |

---

## Daily Workflow & Maintenance

### When Making or Testing Local Changes
Run in the repository root (or from any directory) to test your edits:
```bash
nixos-apply-local
```

### When Pulling Changes from Git
To fetch latest Git changes and re-apply both NixOS and Home Manager:
```bash
nixos-apply-remote
```

### Formatting Nix Code

This repository uses [Alejandra](https://github.com/kamadorueda/alejandra) as the code formatter:

```bash
nix fmt -- .
```

### Updating Flake Dependencies

To update all flake inputs (Nixpkgs, Home Manager, NixOS-WSL, etc.):

```bash
nix flake update
```

---

## Local Overrides & Secrets

For machine-specific or secret environment variables, create `~/.zshrc.local` (ignored by Git). It will be automatically sourced by `.zshrc` if present:

```bash
touch ~/.zshrc.local
```
