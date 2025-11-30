"""
Execution module for building Arch Linux packages using makepkg.

This module handles building packages from PKGBUILD files, including reading
PKGBUILDs from salt://, Jinja templating, and package installation.
"""
from typing import Optional, Dict, Any
import logging
import re
import tempfile
import os

from salt.exceptions import CommandExecutionError, SaltInvocationError
from salt_types import FileManagedArgs

log = logging.getLogger(__name__)


def _parse_pkgbuild_name(pkgbuild_content: str) -> Optional[str]:
    """Parse the package name from PKGBUILD content.

    Arguments:
        pkgbuild_content: The content of the PKGBUILD file

    Returns:
        The package name, or None if not found
    """
    # Look for pkgname= or pkgname =
    match = re.search(r'^pkgname\s*=\s*["\']?([^"\')\s]+)["\']?', pkgbuild_content, re.MULTILINE)
    if match:
        return match.group(1)
    return None


def get_pkgname(source: str, **file_args) -> Optional[str]:
    """Get the package name from a PKGBUILD source.

    Arguments:
        source: Path to PKGBUILD file (can be salt:// URI or local path)
        **file_args: File-managed style arguments (template, context, defaults, saltenv, etc.)

    Returns:
        The package name, or None if not found

    Raises:
        SaltInvocationError: If the PKGBUILD cannot be retrieved or parsed
    """
    pkgbuild_content = __salt__["salt_file_utils.get_managed_file_content"](
        source=source,
        **file_args
    )
    return _parse_pkgbuild_name(pkgbuild_content)


def is_installed(pkgname: str) -> bool:
    """Check if a package is installed.

    Arguments:
        pkgname: The name of the package to check

    Returns:
        True if the package is installed, False otherwise
    """
    try:
        __salt__["pacman_build.run_cmd"](f"pacman --query --info {pkgname}")
        return True
    except CommandExecutionError:
        return False


def installed(
    source: str,
    install_deps: bool = True,
    check: bool = True,
    **file_args
) -> Dict[str, Any]:
    """Build and install a package from a PKGBUILD file.

    Arguments:
        source: Path to PKGBUILD file (can be salt:// URI or local path)
        install_deps: Whether makepkg should install missing dependencies
        check: Whether to run makepkg's check function
        **file_args: File-managed style arguments (template, context, defaults, saltenv, etc.)

    Returns:
        Dictionary with keys:
        - success: Boolean indicating if the operation succeeded
        - pkgname: The name of the package
        - message: Human-readable message about the result

    Raises:
        SaltInvocationError: If parameters are invalid
        CommandExecutionError: If makepkg command fails
    """
    # Get PKGBUILD contents using the shared utility
    pkgbuild_content = __salt__["salt_file_utils.get_managed_file_content"](
        source=source,
        **file_args
    )

    # Parse package name
    pkgname = _parse_pkgbuild_name(pkgbuild_content)
    if not pkgname:
        raise SaltInvocationError("Could not parse package name from PKGBUILD")

    # Check if already installed
    try:
        __salt__["pacman_build.run_cmd"](f"pacman --query --info {pkgname}")
        # Package already installed
        return {
            "success": True,
            "pkgname": pkgname,
            "message": f"Package {pkgname} is already installed"
        }
    except CommandExecutionError:
        # Not installed, continue with build
        pass

    # Build makepkg command
    makepkg_args = ["makepkg", "--noconfirm", "--install"]

    if install_deps:
        makepkg_args.append("--syncdeps")

    if not check:
        makepkg_args.append("--nocheck")

    # Create a temporary directory for the build
    with tempfile.TemporaryDirectory() as tmpdir:
        # Get the build user to set proper permissions
        build_user = __salt__["pacman_build.get_build_user"]()

        # Set ownership and permissions so the build user can access it
        if build_user:
            import pwd
            import stat
            uid = pwd.getpwnam(build_user).pw_uid
            gid = pwd.getpwnam(build_user).pw_gid
            os.chown(tmpdir, uid, gid)
            os.chmod(tmpdir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IROTH | stat.S_IXOTH)

        # Write PKGBUILD to temp directory
        pkgbuild_path = os.path.join(tmpdir, "PKGBUILD")
        with open(pkgbuild_path, 'w') as f:
            f.write(pkgbuild_content)

        # Set ownership of PKGBUILD file too
        if build_user:
            os.chown(pkgbuild_path, uid, gid)

        # Run makepkg in the temp directory
        cmd = " ".join(makepkg_args)
        try:
            output = __salt__["pacman_build.run_cmd"](cmd, cwd=tmpdir)
            return {
                "success": True,
                "pkgname": pkgname,
                "message": f"Successfully built and installed {pkgname}"
            }
        except CommandExecutionError as e:
            return {
                "success": False,
                "pkgname": pkgname,
                "message": f"Failed to build {pkgname}: {e}"
            }
