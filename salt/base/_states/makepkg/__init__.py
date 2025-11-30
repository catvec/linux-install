"""
Salt state module for building and installing Arch Linux packages with makepkg.

This state module provides the `installed` state for building packages from PKGBUILD files.
"""
from typing import Optional, Dict, Any, Union
import logging
from salt_types import SaltStateRes, SaltStateResChanges

log = logging.getLogger(__name__)


def installed(
    name: str,
    source: Optional[str] = None,
    upstream_source: Optional[str] = None,
    patches: Optional[list] = None,
    install_deps: bool = True,
    check: bool = True,
    **file_args
) -> SaltStateRes:
    """Build and install a package from a PKGBUILD file.

    Arguments:
        name: Path to PKGBUILD file, or state name if source/upstream_source is specified
        source: Path to PKGBUILD file (can be salt:// URI or local path). Defaults to name.
        upstream_source: Package name to fetch from ABS/AUR using yay -G
        patches: List of patch files (salt:// URIs) to apply to the PKGBUILD
        install_deps: Whether makepkg should install missing dependencies
        check: Whether to run makepkg's check function
        **file_args: File-managed style arguments (template, context, defaults, etc.)

    Returns:
        Salt state result dictionary

    Example:
        .. code-block:: yaml

            # Using name as source
            salt://my-packages/PKGBUILD:
              makepkg.installed

            # Using explicit source
            my-custom-package:
              makepkg.installed:
                - source: salt://my-packages/PKGBUILD
                - template: jinja
                - context:
                    version: 1.2.3
                - install_deps: True
                - check: True
    """
    # Validate that exactly one of source or upstream_source is provided
    if source and upstream_source:
        return SaltStateRes(
            name=name,
            result=False,
            changes={},
            comment="Cannot specify both 'source' and 'upstream_source'",
        )

    # Default source to name if neither source nor upstream_source provided
    if source is None and upstream_source is None:
        source = name

    # Get package name from PKGBUILD (for test mode and validation)
    # For upstream_source, we'll use the package name directly
    if upstream_source:
        pkgname = upstream_source
    else:
        try:
            pkgname = __salt__["makepkg.get_pkgname"](
                source=source,
                **file_args
            )

            if not pkgname:
                return SaltStateRes(
                    name=name,
                    result=False,
                    changes={},
                    comment=f"Could not parse package name from PKGBUILD at {source}",
                )
        except Exception as e:
            return SaltStateRes(
                name=name,
                result=False,
                changes={},
                comment=f"Error retrieving PKGBUILD from {source}: {e}",
            )

    # Check if package is already installed
    is_installed = __salt__["makepkg.is_installed"](pkgname)

    # Check if in test mode
    if __opts__["test"]:
        if is_installed:
            return SaltStateRes(
                name=name,
                result=True,
                changes={},
                comment=f"Package {pkgname} is already installed",
            )
        else:
            return SaltStateRes(
                name=name,
                result=None,
                changes=SaltStateResChanges(
                    old=f"{pkgname} not installed",
                    new=f"{pkgname} installed"
                ),
                comment=f"Would build and install {pkgname} from {source}",
            )

    # Call the execution module
    try:
        result = __salt__["makepkg.installed"](
            source=source,
            upstream_source=upstream_source,
            patches=patches,
            install_deps=install_deps,
            check=check,
            **file_args
        )

        if result["success"]:
            message = result["message"]

            # Check if package was already installed (no changes)
            if "already installed" in message:
                return SaltStateRes(
                    name=name,
                    result=True,
                    changes={},
                    comment=message,
                )

            # Package was built and installed
            return SaltStateRes(
                name=name,
                result=True,
                changes=SaltStateResChanges(
                    old=f"{pkgname} not installed",
                    new=f"{pkgname} installed"
                ),
                comment=message,
            )
        else:
            # Build/install failed
            return SaltStateRes(
                name=name,
                result=False,
                changes={},
                comment=result["message"],
            )

    except Exception as e:
        return SaltStateRes(
            name=name,
            result=False,
            changes={},
            comment=f"Error: {e}",
        )
