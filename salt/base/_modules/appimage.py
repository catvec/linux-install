"""
Salt execution module for managing AppImage applications.

This module provides functions to download and install AppImages to a global
executable directory with proper permissions.
"""

import os
import stat
import hashlib
import logging
import shutil
from typing import Optional, Dict, Any

from salt.exceptions import CommandExecutionError, SaltInvocationError

log = logging.getLogger(__name__)

__virtualname__ = "appimage"


def __virtual__():
    """
    Only load this module on Linux systems.
    """
    return __virtualname__


def installed(
    name: str,
    source: str,
    target_dir: str = "/usr/local/bin",
    checksum: Optional[str] = None,
    checksum_type: str = "sha256",
    force: bool = False,
) -> Dict[str, Any]:
    """
    Download and install an AppImage to a global executable directory.

    :param name: The name to give the AppImage (e.g., 'myapp')
    :type name: str
    :param source: URL to download the AppImage from (http://, https://, or salt://)
    :type source: str
    :param target_dir: Directory where the AppImage will be installed
    :type target_dir: str
    :param checksum: Optional checksum to verify the download
    :type checksum: str or None
    :param checksum_type: Type of checksum
    :type checksum_type: str
    :param force: Force download even if file exists
    :type force: bool
    :return: Dict with 'result', 'comment', 'changes' keys
    :rtype: dict

    CLI Example:

    .. code-block:: bash

        salt '*' appimage.installed myapp source=https://example.com/app.AppImage
        salt '*' appimage.installed myapp source=salt://appimages/app.AppImage target_dir=/opt/bin
    """
    target_path = os.path.join(target_dir, name)
    changes = {}

    # Check if already installed and not forcing reinstall
    if os.path.exists(target_path) and not force:
        if checksum:
            existing_checksum = _get_file_checksum(target_path, checksum_type)
            if existing_checksum == checksum:
                return {
                    "result": True,
                    "comment": f"AppImage {name} is already installed with correct checksum",
                    "changes": {},
                }
        else:
            return {
                "result": True,
                "comment": f"AppImage {name} is already installed (use force=True to reinstall)",
                "changes": {},
            }

    # Create target directory if it doesn't exist
    if not os.path.exists(target_dir):
        try:
            os.makedirs(target_dir, mode=0o755, exist_ok=True)
            changes["directory"] = f"Created {target_dir}"
        except OSError as e:
            raise CommandExecutionError(f"Failed to create directory {target_dir}: {e}")

    # Download the AppImage
    try:
        downloaded_path = _download_file(source, checksum, checksum_type)
        changes["downloaded"] = source
    except Exception as e:
        raise CommandExecutionError(f"Failed to download AppImage from {source}: {e}")

    # Move to target location
    try:
        # If target exists and we're forcing, back it up first
        if os.path.exists(target_path):
            backup_path = f"{target_path}.bak"
            os.rename(target_path, backup_path)
            changes["backup"] = backup_path

        # Copy downloaded file to target
        __salt__["file.copy"](downloaded_path, target_path, remove_existing=True)
        changes["installed"] = target_path
    except Exception as e:
        raise CommandExecutionError(f"Failed to install AppImage to {target_path}: {e}")

    # Set executable permissions
    try:
        # rwxr-xr-x (755)
        os.chmod(target_path, stat.S_IRWXU | stat.S_IRGRP | stat.S_IXGRP | stat.S_IROTH | stat.S_IXOTH)
        changes["permissions"] = "755"
    except OSError as e:
        raise CommandExecutionError(f"Failed to set permissions on {target_path}: {e}")

    return {
        "result": True,
        "comment": f"AppImage {name} successfully installed to {target_path}",
        "changes": changes,
    }


def removed(name: str, target_dir: str = "/usr/local/bin") -> Dict[str, Any]:
    """
    Remove an installed AppImage.

    :param name: The name of the AppImage to remove
    :type name: str
    :param target_dir: Directory where the AppImage is installed
    :type target_dir: str
    :return: Dict with 'result', 'comment', 'changes' keys
    :rtype: dict

    CLI Example:

    .. code-block:: bash

        salt '*' appimage.removed myapp
        salt '*' appimage.removed myapp target_dir=/opt/bin
    """
    target_path = os.path.join(target_dir, name)

    if not os.path.exists(target_path):
        return {
            "result": True,
            "comment": f"AppImage {name} is not installed",
            "changes": {},
        }

    try:
        os.remove(target_path)
        return {
            "result": True,
            "comment": f"AppImage {name} removed from {target_path}",
            "changes": {"removed": target_path},
        }
    except OSError as e:
        raise CommandExecutionError(f"Failed to remove {target_path}: {e}")


def is_installed(name: str, target_dir: str = "/usr/local/bin") -> bool:
    """
    Check if an AppImage is installed.

    :param name: The name of the AppImage
    :type name: str
    :param target_dir: Directory where the AppImage should be installed
    :type target_dir: str
    :return: True if installed, False otherwise
    :rtype: bool

    CLI Example:

    .. code-block:: bash

        salt '*' appimage.is_installed myapp
    """
    target_path = os.path.join(target_dir, name)
    return os.path.exists(target_path) and os.access(target_path, os.X_OK)


def _download_file(source: str, checksum: Optional[str] = None, checksum_type: str = "sha256") -> str:
    """
    Download a file from a URL or salt:// source.

    :param source: URL or salt:// path to download from
    :type source: str
    :param checksum: Optional checksum to verify
    :type checksum: str or None
    :param checksum_type: Type of checksum
    :type checksum_type: str
    :return: Path to the downloaded file
    :rtype: str
    """
    if source.startswith("salt://"):
        # Use Salt's file caching mechanism
        cached_path = __salt__["cp.cache_file"](source)
        if not cached_path:
            raise SaltInvocationError(f"Failed to cache file from {source}")

        if checksum:
            actual_checksum = _get_file_checksum(cached_path, checksum_type)
            if actual_checksum != checksum:
                raise CommandExecutionError(
                    f"Checksum mismatch: expected {checksum}, got {actual_checksum}"
                )

        return cached_path
    else:
        # Use Salt's cp.get_url function for HTTP(S) URLs
        import tempfile
        temp_dir = tempfile.gettempdir()
        temp_path = os.path.join(temp_dir, f"appimage-{hashlib.md5(source.encode()).hexdigest()}")

        # Build source_hash parameter if checksum provided
        source_hash = None
        if checksum:
            source_hash = f"{checksum_type}={checksum}"

        download_result = __salt__["cp.get_url"](
            path=source,
            dest=temp_path,
            source_hash=source_hash,
        )

        if not download_result or not os.path.exists(temp_path):
            raise CommandExecutionError(f"Failed to download file from {source}")

        return temp_path


def _get_file_checksum(path: str, checksum_type: str = "sha256") -> str:
    """
    Calculate the checksum of a file.

    :param path: Path to the file
    :type path: str
    :param checksum_type: Type of checksum
    :type checksum_type: str
    :return: Hexadecimal checksum string
    :rtype: str
    """
    if checksum_type not in hashlib.algorithms_available:
        raise SaltInvocationError(f"Unsupported checksum type: {checksum_type}")

    hash_obj = hashlib.new(checksum_type)
    with open(path, "rb") as f:
        while chunk := f.read(8192):
            hash_obj.update(chunk)

    return hash_obj.hexdigest()
