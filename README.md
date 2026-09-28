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

Follow these steps to configure the system, create the `jackw` user, and load the environment.

### 1. Clone the Repository

Inside the initial `nixos` WSL shell:

```bash
git clone https://github.com/jackmaders/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Apply System Configuration

Build and activate the NixOS system configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

This step:
- Configures NixOS-WSL and sets `jackw` as the default user in `/etc/wsl.conf`.
- Creates the `jackw` user account with passwordless `sudo` (`wheel` group).
- Enables Zsh system-wide and sets it as the default login shell.

### 3. Apply Home Manager Profile

Apply the desired user configuration profile for `jackw`:

#### For Personal Machine:
```bash
nix run github:nix-community/home-manager -- switch --flake ".#personal"
```

#### For Work Machine (Twinkl):
```bash
nix run github:nix-community/home-manager -- switch --flake ".#twinkl"
```

### 4. Restart WSL From Windows

WSL only re-reads `/etc/wsl.conf` after a full shutdown. Open **Windows PowerShell** or **Command Prompt** and run:

```powershell
wsl.exe --shutdown
```

### 5. Launch NixOS

Launch WSL from PowerShell or Windows Terminal:

```powershell
wsl -d NixOS
```

You will automatically log in as **`jackw`** with **Zsh**, Starship prompt, and all CLI tools ready.

---

## Daily Workflow & Maintenance

### Applying Updates After `git pull`

#### User Configuration (Dotfiles, Aliases, Tools)
```bash
cd ~/dev/dotfiles
git pull

# Personal profile:
nix run github:nix-community/home-manager -- switch --flake ".#personal"

# Work profile:
nix run github:nix-community/home-manager -- switch --flake ".#twinkl"
```

#### System Configuration (WSL, System Packages, Users)
```bash
cd ~/dev/dotfiles
git pull
sudo nixos-rebuild switch --flake .#nixos
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
