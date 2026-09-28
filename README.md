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

## Fresh Machine Setup (NixOS-WSL)

When installing a fresh NixOS-WSL instance, the initial session defaults to the `nixos` user with Bash:

```
[nixos@nixos:/mnt/c/Users/...]$
```

You can run the entire setup directly from **Windows PowerShell** without opening or swapping between interactive WSL shells.

### Method 1: 100% Windows PowerShell (Zero Shell Swapping)

Run these 3 commands directly in **PowerShell**:

#### 1. Provision System & User from GitHub
```powershell
wsl -d NixOS -u root -- nixos-rebuild switch --flake "github:jackmaders/dotfiles#nixos"
```

#### 2. Restart WSL (to activate `jackw` as default user)
```powershell
wsl --shutdown
```

#### 3. Provision Home Manager Profile
- **For Work (Twinkl):**
  ```powershell
  wsl -d NixOS -u jackw -- nix run github:nix-community/home-manager -- switch --flake "github:jackmaders/dotfiles#twinkl"
  ```
- **For Personal:**
  ```powershell
  wsl -d NixOS -u jackw -- nix run github:nix-community/home-manager -- switch --flake "github:jackmaders/dotfiles#personal"
  ```

That's it! Launch WSL:
```powershell
wsl -d NixOS
```
You will enter directly into `jackw` with Zsh, your complete prompt, aliases, and tools ready.

---

### Method 2: From Inside the WSL Shell

If you are already inside the initial `[nixos@nixos:...]$` shell:

```bash
# 1. Apply system configuration
sudo nixos-rebuild switch --flake "github:jackmaders/dotfiles#nixos"
```

In Windows PowerShell:
```powershell
wsl --shutdown
wsl -d NixOS
```

Then inside `jackw`:
```bash
# For Personal:
nix run github:nix-community/home-manager -- switch --flake "github:jackmaders/dotfiles#personal"

# Or For Work (Twinkl):
nix run github:nix-community/home-manager -- switch --flake "github:jackmaders/dotfiles#twinkl"
```

---

## Quick Commands

The environment includes clear, self-explanatory commands to refresh your system and user configurations from any directory:

| Command | Action | Description |
|---|---|---|
| **`refresh-config`** | **Refresh Everything** | Rebuilds and activates **both** NixOS system configuration and your active Home Manager profile (`personal` or `twinkl`). |
| **`update-config`** | **Pull & Refresh Everything** | Runs `git pull` on your dotfiles and immediately runs `refresh-config` to apply all changes. |
| `rebuild-home` | Refresh User Only | Rebuilds only the Home Manager environment. |
| `rebuild-system` | Refresh System Only | Rebuilds only the NixOS system environment (`sudo nixos-rebuild switch`). |

> [!TIP]
> You can also specify an explicit profile if needed (e.g. `refresh-config twinkl` or `rebuild-home personal`). By default, it automatically uses the machine's active profile.

---

## Daily Workflow & Maintenance

### When Making Local Changes
After editing files in your dotfiles repository:
```bash
refresh-config
```

### When Pulling Changes on Another Machine
To pull down the latest commits and apply both system and user configurations in one step:
```bash
update-config
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
