"""
Salt state module for managing AppImage applications.

This module provides declarative state management for AppImages.
"""

import os
import re
from typing import Optional, Dict, Any, List, Union
from urllib.parse import urlparse


def _extract_name_from_source(source: str) -> str:
    """
    Extract a suitable name from a source URL.

    :param source: Source URL or path
    :type source: str
    :return: Extracted name without .AppImage extension
    :rtype: str
    """
    if source.startswith("salt://"):
        path = source[7:]
    else:
        parsed = urlparse(source)
        path = parsed.path

    filename = os.path.basename(path)
    # Remove .AppImage extension
    name = re.sub(r'\.AppImage$', '', filename, flags=re.IGNORECASE)
    return name


def _install_single(
    name: str,
    source: str,
    target_dir: str = "/usr/local/bin",
    checksum: Optional[str] = None,
    checksum_type: str = "sha256",
    force: bool = False,
) -> Dict[str, Any]:
    """
    Install a single AppImage.

    :param name: The name to give the AppImage
    :type name: str
    :param source: URL to download the AppImage from
    :type source: str
    :param target_dir: Directory where the AppImage will be installed
    :type target_dir: str
    :param checksum: Optional checksum to verify the download
    :type checksum: str or None
    :param checksum_type: Type of checksum
    :type checksum_type: str
    :param force: Force download even if file exists
    :type force: bool
    :return: Salt state result dictionary
    :rtype: dict
    """
    ret = {
        "name": name,
        "result": True,
        "changes": {},
        "comment": "",
    }

    # Check if already installed
    is_installed = __salt__["appimage.is_installed"](name, target_dir=target_dir)

    if is_installed and not force:
        ret["comment"] = f"AppImage {name} is already installed"
        if __opts__["test"]:
            ret["result"] = None
        return ret

    if __opts__["test"]:
        ret["result"] = None
        if is_installed:
            ret["comment"] = f"AppImage {name} would be reinstalled"
        else:
            ret["comment"] = f"AppImage {name} would be installed"
        ret["changes"] = {
            "old": "installed" if is_installed else "not installed",
            "new": "installed",
        }
        return ret

    # Install the AppImage
    try:
        install_result = __salt__["appimage.installed"](
            name=name,
            source=source,
            target_dir=target_dir,
            checksum=checksum,
            checksum_type=checksum_type,
            force=force,
        )

        if install_result["result"]:
            ret["changes"] = install_result["changes"]
            ret["comment"] = install_result["comment"]
        else:
            ret["result"] = False
            ret["comment"] = install_result.get("comment", "Installation failed")

    except Exception as e:
        ret["result"] = False
        ret["comment"] = f"Failed to install AppImage {name}: {e}"

    return ret


def installed(
    name: str,
    source: Optional[str] = None,
    target_dir: str = "/usr/local/bin",
    checksum: Optional[str] = None,
    checksum_type: str = "sha256",
    force: bool = False,
    pkgs: Optional[List[Dict[str, Any]]] = None,
) -> Dict[str, Any]:
    """
    Ensure an AppImage is installed to a global executable directory.

    This state supports two modes:
    1. Single package mode: Provide source parameter directly
    2. Multiple packages mode: Provide pkgs parameter with list of package definitions

    :param name: The name to give the AppImage or state ID when using pkgs
    :type name: str
    :param source: URL to download the AppImage from (not used if pkgs is provided)
    :type source: str or None
    :param target_dir: Directory where the AppImage will be installed
    :type target_dir: str
    :param checksum: Optional checksum to verify the download
    :type checksum: str or None
    :param checksum_type: Type of checksum
    :type checksum_type: str
    :param force: Force download even if file exists
    :type force: bool
    :param pkgs: List of package definitions for installing multiple AppImages
    :type pkgs: list of dict or None
    :return: Salt state result dictionary
    :rtype: dict

    Example (single package):

    .. code-block:: yaml

        obsidian:
          appimage.installed:
            - source: https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage
            - target_dir: /usr/local/bin
            - checksum: abc123...
            - checksum_type: sha256

    Example (multiple packages):

    .. code-block:: yaml

        my_appimages:
          appimage.installed:
            - pkgs:
              - source: https://example.com/app1.AppImage
                checksum: abc123...
              - source: https://example.com/app2.AppImage
                name: custom-name
                target_dir: /opt/bin
    """
    # Handle multiple packages
    if pkgs is not None:
        results = []
        all_changes = {}
        all_comments = []

        for pkg_def in pkgs:
            if not isinstance(pkg_def, dict):
                return {
                    "name": name,
                    "result": False,
                    "changes": {},
                    "comment": f"Invalid package definition: {pkg_def}. Must be a dictionary.",
                }

            if "source" not in pkg_def:
                return {
                    "name": name,
                    "result": False,
                    "changes": {},
                    "comment": "Package definition must include 'source' field",
                }

            pkg_source = pkg_def["source"]
            pkg_name = pkg_def.get("name") or _extract_name_from_source(pkg_source)
            pkg_target_dir = pkg_def.get("target_dir", target_dir)
            pkg_checksum = pkg_def.get("checksum")
            pkg_checksum_type = pkg_def.get("checksum_type", checksum_type)
            pkg_force = pkg_def.get("force", force)

            result = _install_single(
                name=pkg_name,
                source=pkg_source,
                target_dir=pkg_target_dir,
                checksum=pkg_checksum,
                checksum_type=pkg_checksum_type,
                force=pkg_force,
            )

            results.append(result)
            if result["changes"]:
                all_changes[pkg_name] = result["changes"]
            all_comments.append(f"{pkg_name}: {result['comment']}")

        # Aggregate results
        all_succeeded = all(r["result"] for r in results)
        any_failed = any(r["result"] is False for r in results)

        return {
            "name": name,
            "result": False if any_failed else (None if any(r["result"] is None for r in results) else True),
            "changes": all_changes,
            "comment": "\n".join(all_comments),
        }

    # Handle single package
    if source is None:
        return {
            "name": name,
            "result": False,
            "changes": {},
            "comment": "Either 'source' or 'pkgs' parameter must be provided",
        }

    return _install_single(
        name=name,
        source=source,
        target_dir=target_dir,
        checksum=checksum,
        checksum_type=checksum_type,
        force=force,
    )


def removed(name: str, target_dir: str = "/usr/local/bin") -> Dict[str, Any]:
    """
    Ensure an AppImage is removed.

    :param name: The name of the AppImage to remove
    :type name: str
    :param target_dir: Directory where the AppImage is installed
    :type target_dir: str
    :return: Salt state result dictionary
    :rtype: dict

    Example:

    .. code-block:: yaml

        old-app:
          appimage.removed:
            - target_dir: /usr/local/bin
    """
    ret = {
        "name": name,
        "result": True,
        "changes": {},
        "comment": "",
    }

    # Check if installed
    is_installed = __salt__["appimage.is_installed"](name, target_dir=target_dir)

    if not is_installed:
        ret["comment"] = f"AppImage {name} is not installed"
        if __opts__["test"]:
            ret["result"] = None
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"AppImage {name} would be removed"
        ret["changes"] = {
            "old": "installed",
            "new": "not installed",
        }
        return ret

    # Remove the AppImage
    try:
        remove_result = __salt__["appimage.removed"](name=name, target_dir=target_dir)

        if remove_result["result"]:
            ret["changes"] = remove_result["changes"]
            ret["comment"] = remove_result["comment"]
        else:
            ret["result"] = False
            ret["comment"] = remove_result.get("comment", "Removal failed")

    except Exception as e:
        ret["result"] = False
        ret["comment"] = f"Failed to remove AppImage {name}: {e}"

    return ret
