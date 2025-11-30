# States
Custom Salt states.

> **Note**: See also [custom Salt execution modules](../_modules/README.md) which provide the underlying functionality.

# Table Of Contents
- [Overview](#overview)
- [Development](#development)

# Overview
Provides several custom Salt states:

- `aurpkg`: Manages AUR packages from the Arch Linux auxiliary package repository
  - `check_installed(name: str, pkgs: Optional[List[str]])`: Checks the specified package(s) are installed
  - `installed(name: str, pkgs: Optional[List[str]])`: Ensures the specified package(s)s are installed
- `makepkg`: Build and install Arch Linux packages from PKGBUILD files
  - `installed(name: str, source: Optional[str], install_deps: bool, check: bool, **file_args)`: Build and install a package from a PKGBUILD with support for salt:// URIs and Jinja templating
- `user_service`: Manages services run in a user's session
  - `enabled(name: str, user: str, start: bool)`: Enables a service for a user, if `start` given then the service is also started
  - `disabled(name: str, user: str, stop: bool)`: Disables a service for a user, if `stop` is given the service is also stopped
  - `running(name: str, user: str)`: Ensure a service for a user is running
  - `stopped(name: str, user: str)`: Ensure a service for a user is stopped
  - `masked(name: str, user: str)`: Ensure a service for a user is masked
  - `unmasked(name: str, user: str)`: Ensure a service for a user is not masked
- `multipkg`: Installs packages using multiple different package manager Salt states (ex., `pkg` and `aurpkg`)
  - `installed(name: str, pkgs: List[PkgDef])`: Installs packages specified by package definitions in `pkgs`, these definitions must be one of the following formats:
      - List of dictionaries with only one key. Where the key is the name of the Salt state used to install the package named by value. The value can either be a single package or a list of packages. In this list a dictionary key can only appear once
      - List of strings or single string. The default `pkg` state is used to install these packages
  Packages is a list of dictionaries where each only has one key, being the Salt state to install packages in the value via
  
# Development
After making changes to any states the following command must be run:

```
sudo salt-call --local saltutil.sync_states
```
