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
