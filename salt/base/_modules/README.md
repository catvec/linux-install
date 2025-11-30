# Modules
Custom Salt execution modules.

> **Note**: See also [custom Salt states](../_states/README.md) which use these modules.

# Table Of Contents
- [Overview](#overview)
- [Development](#development)

# Overview
Provides several custom Salt execution modules:

- `salt_types`: Shared type definitions (TypedDicts) used across custom states and modules
  - `SaltStateRes`: Return type for Salt state functions
  - `SaltStateResChanges`: Change descriptions for state results
  - `FileManagedArgs`: Arguments for file.managed-style file handling
- `salt_file_utils`: Utility functions for file handling
  - `extract_file_managed_args(**kwargs)`: Extracts file.managed arguments from kwargs
  - `get_managed_file_content(source, template, context, defaults, saltenv, **kwargs)`: Retrieves and optionally renders files from salt:// URIs
- `pacman_build`: Run commands as the configured non-root build user
  - `get_build_user()`: Get the configured non-root builder from minion config
  - `run_cmd(cmd, **kwargs)`: Run a command as the build user
- `makepkg`: Build Arch Linux packages from PKGBUILD files
  - `get_pkgname(source, **file_args)`: Extract package name from a PKGBUILD
  - `is_installed(pkgname)`: Check if a package is installed
  - `installed(source, install_deps, check, **file_args)`: Build and install a package from PKGBUILD

# Development
After making changes to any modules the following command must be run:

```
sudo salt-call --local saltutil.sync_modules
```
