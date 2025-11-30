"""
Execution module for Pacman-related build operations.

This module provides utilities for running build commands (like makepkg, yay, etc.)
as a non-root user, as required by Arch Linux packaging tools.

Configuration
=============
Configure the build user via the Salt minion configuration file:

```yaml
pacman:
  nonroot_builder: <USER>
```
"""
from typing import Optional
import logging

from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)

OPTS_PARENT_KEY = "pacman"
OPTS_BUILD_USER_KEY = "nonroot_builder"


def get_build_user() -> Optional[str]:
    """Get the configured non-root build user from minion configuration.

    Returns:
        The username of the build user, or None if not configured.
    """
    return __opts__.get(OPTS_PARENT_KEY, {}).get(OPTS_BUILD_USER_KEY, None)


def run_cmd(cmd: str, **kwargs) -> str:
    """Run a command as the configured build user.

    This function inspects the minion configuration to determine what user to run
    the command as, then executes it using cmd.run.

    Arguments:
        cmd: Command to run
        **kwargs: Additional keyword arguments to pass to cmd.run (e.g., stdin, cwd, env)

    Returns:
        String output of command

    Raises:
        CommandExecutionError: If the command exits with a non-zero exit code
    """
    run_kwargs = {
        "cmd": cmd,
        "raise_err": True,
    }

    # Merge in any additional kwargs
    run_kwargs.update(kwargs)

    # Figure out if we want to run as a specific user
    build_user = get_build_user()

    if build_user is not None:
        run_kwargs["runas"] = build_user
        run_kwargs["group"] = build_user

    # Run command
    return __salt__["cmd.run"](**run_kwargs)
