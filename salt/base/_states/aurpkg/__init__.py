"""
Overview
========
Invokes the Yay AUR package manager. This utility is similar to pacman but for the auxiliary package repository which is less maintained.

Configuration
=============
The module requires configuration via the Salt minion file.

The Yay utility does not allow itself to be run as the root user. This is because it builds unknown source code.
Configure the user for which Yay runs as by setting the nonroot_builder field under pacman configuration.

```yaml
pacman:
  nonroot_builder: <USER>
```
"""
from typing import Optional, List
import logging

from salt.exceptions import CommandExecutionError
from salt_types import SaltStateRes, SaltStateResChanges

log = logging.getLogger(__name__)
    

def _installed(name: str, pkgs: List[str]) -> SaltStateRes:
    """ Ensure packages are installed. Actual business logic behind installed state.
    Arguments:
    - name: ID of state block
    - pkgs: Packages to install

    Returns: Install result
    """
    pkgs_space_sep_str = " ".join(pkgs)

    res = SaltStateRes(
            name=name,
        result=True,
        changes=SaltStateResChanges(
            old=f"not all of {pkgs} installed",
            new=f"{pkgs} installed",
        ),
        comment="",
    )

    try:
        __salt__["pacman_build.run_cmd"](f"yay --sync --refresh --noconfirm {pkgs_space_sep_str}")
    except CommandExecutionError:
        res["result"] = False
        res["changes"]["new"] = f"{pkgs} failed to installed"

    return res

def _check_installed(name: str, pkgs: List[str]) -> SaltStateRes:
    """ Check if package is installed. Business logic behind check_installed state.
    Arguments:
    - name: ID of state block
    - pkgs: Packages to ensure are installed

    Returns: Check result
    """
    pkgs_space_sep_str = " ".join(pkgs)
    is_installed = True

    try:
        __salt__["pacman_build.run_cmd"](f"yay --query --info {pkgs_space_sep_str}")
    except CommandExecutionError:
        is_installed = False

    pkgs_str = ", ".join(pkgs)
    installed_comment = f"{pkgs_str} installed" if is_installed else f"{pkgs_str} not installed",

    return SaltStateRes(
        name=name,
        result=is_installed,
        changes=SaltStateResChanges(
            old="",
            new=installed_comment
        ),
        comment=installed_comment,
    )
    

def check_installed(name: str, pkgs: Optional[List[str]]=None) -> SaltStateRes:
    """ Determines if a package is installed.
    Arguments:
    - name: Either package to check is installed or just name of state if pkgs is set
    - pkgs: If set then this is used as a list of packages to check are installed over name

    Returns: Check result
    """
    return _check_installed(name=name, pkgs=pkgs if pkgs is not None else [name])


def installed(name: str, pkgs: Optional[List[str]]=None) -> SaltStateRes:
    """ Ensures AUR packages are installed.
    Arguments:
    - name: Either package to install or just name of state if pkgs is set
    - pkgs: If set then this is used as a list of packages to install over name

    Returns: Install result
    """
    # Check if already installed
    pkgs_str = ", ".join(pkgs) if pkgs is not None else name
    check_res = check_installed(name=name, pkgs=pkgs)
    
    # Check if in test mode
    if __opts__["test"]:
        res = SaltStateRes(
            name=name,
            result=None,
            changes=SaltStateResChanges(
                old=f"{pkgs_str} not installed",
                new=f"{pkgs_str} installed",
            ),
            comment=f"would have installed {pkgs_str}",
        )
            
        if check_res["result"]:
            res["result"] = True
            res["changes"] = {}
            res["comment"] = f"{pkgs_str} already installed"

        return res

    if check_res["result"] is True:
        return SaltStateRes(
            name=name,
            result=True,
            changes={},
            comment=f"already installed {pkgs_str}",
        )

    return _installed(name=name, pkgs=pkgs if pkgs is not None else [name])
