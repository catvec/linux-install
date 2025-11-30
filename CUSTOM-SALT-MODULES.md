# Custom Salt Modules, States, and Utilities

This directory structure contains custom Salt modules, states, and utilities for managing Arch Linux packages and system configuration.

## Directory Structure

- `salt/base/_modules/` - Custom execution modules (functions callable via `salt-call`)
- `salt/base/_states/` - Custom state modules (declarative state definitions for `.sls` files)
- `salt/base/_utils/` - Shared utility modules (not directly callable, used by modules and states)

## Development Workflow

After modifying any custom modules, states, or utils, sync them to activate changes:

```bash
# Sync everything
sudo salt-call --local saltutil.sync_all

# Or sync specific types
sudo salt-call --local saltutil.sync_modules
sudo salt-call --local saltutil.sync_states
```

## Available Modules

### Execution Modules (`salt/base/_modules/`)

- **salt_types**: Shared type definitions (TypedDicts) used across custom states and modules
  - `SaltStateRes`: Return type for Salt state functions
  - `SaltStateResChanges`: Change descriptions for state results
  - `FileManagedArgs`: Arguments for file.managed-style file handling

- **salt_file_utils**: Utilities for file handling in Salt modules
  - `get_managed_file_content(source, ...)` - Retrieve and optionally render files from `salt://` URIs
  - `extract_file_managed_args(**kwargs)` - Extract file.managed-style arguments from kwargs

- **pacman_build**: Run commands as a non-root build user
  - `get_build_user()` - Get the configured build user from minion config
  - `run_cmd(cmd, cwd=None)` - Run a command as the build user

- **makepkg**: Build and install Arch Linux packages from PKGBUILD files
  - `installed(source=None, upstream_source=None, patches=None, keep_builddir=False, ...)` - Build and install a package
  - `get_pkgname(source)` - Extract package name from PKGBUILD
  - `is_installed(pkgname)` - Check if a package is installed

### State Modules (`salt/base/_states/`)

- **makepkg**: State module for building and installing packages
  - `makepkg.installed` - Build and install a package from PKGBUILD

- **aurpkg**: Manages AUR packages from the Arch Linux auxiliary package repository
  - `aurpkg.check_installed(name, pkgs)` - Check if packages are installed
  - `aurpkg.installed(name, pkgs)` - Ensure packages are installed

- **user_service**: Manages services run in a user's session
  - `user_service.enabled(name, user, start)` - Enable a user service
  - `user_service.disabled(name, user, stop)` - Disable a user service
  - `user_service.running(name, user)` - Ensure service is running
  - `user_service.stopped(name, user)` - Ensure service is stopped
  - `user_service.masked(name, user)` - Mask a user service
  - `user_service.unmasked(name, user)` - Unmask a user service

- **multipkg**: Install packages using multiple package managers
  - `multipkg.installed(name, pkgs)` - Install packages via different Salt states

## Usage Examples

### Using `upstream_source` to install from AUR/ABS

```yaml
dsd_fme_installed:
  makepkg.installed:
    - upstream_source: dsd-fme
```

This fetches the PKGBUILD and all related files from AUR/ABS using `yay -G`.

### Using `source` with a custom PKGBUILD

```yaml
my_package:
  makepkg.installed:
    - source: salt://my-packages/PKGBUILD
    - template: jinja
    - context:
        version: 1.2.3
```

### Applying patches to upstream PKGBUILDs

```yaml
dsd_fme_installed:
  makepkg.installed:
    - upstream_source: dsd-fme
    - patches:
        - salt://dsd-fme/patches/version-fix.patch
        - salt://dsd-fme/patches/deps-update.patch
```

Patches are applied with `patch` command and should be in unified diff format.

### Using persistent build directory

```yaml
my_package:
  makepkg.installed:
    - upstream_source: my-package
    - keep_builddir: true
```

Builds in `/var/cache/salt/makepkg/<pkgname>` instead of a temporary directory, useful for debugging.
