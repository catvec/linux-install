# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Linux installation and configuration repository** that uses **SaltStack** to automate the setup of Arch Linux (and other distributions) systems. The configuration manages everything from base system packages to desktop environment, development tools, and applications.

### Key Technologies
- **SaltStack** - Configuration management (states and pillars)
- **XBPS** - Void Linux package manager
- **pacman/yay** - Arch Linux package manager (including AUR)
- **systemd** - Service management (including user services)

## Directory Structure

```
/etc/linux-install/
├── live-scripts/          # Scripts run during initial installation from live USB
├── setup-scripts/         # Scripts to prepare the installation media
├── salt/                  # Salt states (configuration files)
│   ├── base/              # Base states (shared across all environments)
│   ├── arch/              # Arch Linux specific states
│   ├── void/              # Void Linux specific states
│   ├── gentoo/            # Gentoo specific states
│   ├── work/              # Work machine states
│   └── wsl/               # WSL specific states
├── pillar/                # Salt pillars (configuration data)
│   ├── base/              # Base pillar data
│   ├── arch/              # Arch-specific pillar data
│   └── [env]/             # Environment-specific pillars
└── secrets/               # Encrypted secrets (git submodule)
```

## Salt Environments

The repository uses Salt environments to customize configuration for different machines:

| Environment | Purpose |
|-------------|---------|
| `base` | Base configuration (shared) |
| `arch` | Arch Linux systems |
| `void` | Void Linux systems |
| `gentoo` | Gentoo Linux systems |
| `work` | Work machine configuration |
| `wsl` | Windows Subsystem for Linux |

The current environment is specified in `/etc/linux-install/environment-flag`.

## Building and Testing

### Running Salt States

```bash
# Apply a specific state
salt-apply -s STATE_NAME

# Apply multiple states
salt-apply -s STATE1,STATE2

# Run in test mode (dry-run)
salt-apply -t -s STATE_NAME

# Specify environment
salt-apply -e ENV_NAME -s STATE_NAME

# Set pillar values
salt-apply -s STATE_NAME -p "key=value"

# View logs
salt-apply -l debug -s STATE_NAME
```

### Manual Salt Commands

```bash
# List available states
salt-call --local state.list_states

# Run highstate (all states for current environment)
salt-call --local state.apply saltenv=arch pillarenv=arch

# Sync custom modules/states (after modifying _modules or _states)
salt-call --local saltutil.sync_all
salt-call --local saltutil.sync_modules
salt-call --local saltutil.sync_states
```

## Custom Salt Modules

### Execution Modules (`salt/base/_modules/`)

| Module | Purpose |
|--------|---------|
| `makepkg` | Build and install Arch Linux packages from PKGBUILDs |
| `pacman_build` | Run commands as non-root build user |
| `salt_file_utils` | File handling utilities (templating, rendering) |
| `salt_types` | Shared type definitions (TypedDicts) |
| `appimage` | Download and install AppImage applications |
| `aurpkg` | Manage AUR packages via yay |
| `multipkg` | Install packages from multiple sources |
| `user_service` | Manage systemd user services |

### State Modules (`salt/base/_states/`)

| State | Purpose |
|-------|---------|
| `makepkg` | `makepkg.installed` - Build/install from PKGBUILD |
| `aurpkg` | `aurpkg.installed` / `aurpkg.check_installed` |
| `multipkg` | `multipkg.installed` - Install via multiple managers |
| `user_service` | `user_service.enabled` / `running` / `stopped` / `masked` |
| `appimage` | `appimage.installed` / `appimage.removed` / `appimage.is_installed` |

## Custom Salt States

### Package Management

**Arch Linux packages** can be installed via:

```yaml
# Standard pacman package
my-package:
  pkg.installed:
    - pkgs:
      - package-name

# AUR package
my-aur-package:
  aurpkg.installed:
    - pkgs:
      - aur-package-name

# Custom PKGBUILD (makepkg)
my-custom-package:
  makepkg.installed:
    - upstream_source: package-name
    - source: salt://path/to/PKGBUILD
    - patches:
      - salt://path/to/patch.patch
    - keep_builddir: true
```

### User Services

```yaml
my-user-service:
  user_service.enabled:
    - name: myservice
    - user: username
    - start: true  # Also start immediately
```

## Configuration Patterns

### Salt Minion Configuration

The minion config is at `salt/base/salt-configuration/minion`. Key settings:
- `file_roots` and `pillar_roots` point to `/srv/salt` and `/srv/pillar`
- `ext_pillar` uses stack module for environment-specific pillars
- `pacman.nonroot_builder` specifies non-root build user

### Pillar Stack Configuration

Pillars in `pillar/*/pillar-stack.cfg` control which pillar files are loaded. Common patterns:

```yaml
# Load all pillars for all hosts
*/*

# Load common pillars + host-specific values
*/init.sls
*/{{ __grains__["id"] }}.sls
```

## Bootstrap Process (for new installations)

1. Create live ISO with `setup-scripts/mk-iso.sh`
2. Create install media with `setup-scripts/mk-install-media.sh`
3. Boot from USB and run `live-scripts/cryptsetup.sh` (if encrypting)
4. Run `live-scripts/install.sh` to install base system
5. In chroot, `live-scripts/setup.sh` runs Salt configuration

## Development Workflow

1. Modify salt states in `salt/base/STATE_NAME/`
2. Modify pillar data in `pillar/base/STATE_NAME/`
3. Sync custom modules: `salt-call --local saltutil.sync_all`
4. Test state: `salt-apply -t -s STATE_NAME`
5. Apply state: `salt-apply -s STATE_NAME`

## Environment Creation

To add a new environment (see `DEV-INSTRUCTIONS.md` for details):
1. Create `salt/NEW_ENV/` and `pillar/NEW_ENV/` directories
2. Copy `pillar/base/pillar-stack.cfg` to `pillar/NEW_ENV/`
3. Create `pillar/NEW_ENV/environment.sls` with `environment: NEW_ENV`
4. Create `pillar/NEW_ENV/top.sls`
5. Update `salt/base/salt-configuration/init.sls` with new environment paths
6. Update `salt/base/salt-configuration/minion` with new environment
7. Update `live-scripts/link-salt-dirs.sh` with new environment links
8. Create `salt/NEW_ENV/top.sls` with state list

## Common Commands Reference

```bash
# Check salt configuration
salt-call --local config.master
salt-call --local config.minion

# View pillar data
salt-call --local pillar.items
salt-call --local pillar.get key_name

# Run specific state
salt-call --local state.apply STATE_NAME

# Check what states are available
salt-call --local state.list_states
```