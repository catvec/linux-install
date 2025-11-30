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
import shutil
import contextlib
import pwd
import stat

from salt.exceptions import CommandExecutionError, SaltInvocationError
from salt_types import FileManagedArgs

log = logging.getLogger(__name__)


@contextlib.contextmanager
def _build_directory(keep: bool, pkg_hint: Optional[str] = None):
    """Context manager for build directory - either temp or persistent.

    Arguments:
        keep: If True, use persistent directory; if False, use temporary directory
        pkg_hint: Optional package name hint for naming the persistent directory

    Yields:
        Path to the build directory
    """
    if keep:
        # Use persistent directory
        base_dir = "/var/cache/salt/makepkg"
        os.makedirs(base_dir, exist_ok=True)

        # Use package name as subdirectory if available, otherwise use temp name
        if pkg_hint:
            builddir = os.path.join(base_dir, pkg_hint)
        else:
            builddir = os.path.join(base_dir, f"build_{os.getpid()}")

        os.makedirs(builddir, exist_ok=True)
        try:
            yield builddir
        finally:
            pass  # Keep the directory
    else:
        # Use temporary directory
        with tempfile.TemporaryDirectory() as tmpdir:
            yield tmpdir


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
        **file_args: File-managed style arguments (template, context, defaults, etc.)

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
    source: Optional[str] = None,
    upstream_source: Optional[str] = None,
    patches: Optional[list] = None,
    keep_builddir: bool = False,
    install_deps: bool = True,
    check: bool = True,
    **file_args
) -> Dict[str, Any]:
    """Build and install a package from a PKGBUILD file.

    Arguments:
        source: Path to PKGBUILD file (can be salt:// URI or local path)
        upstream_source: Package name to fetch from ABS/AUR using yay -G
        patches: List of patch files (salt:// URIs) to apply to the PKGBUILD
        keep_builddir: If True, use persistent directory at /var/cache/salt/makepkg/<pkgname>
        install_deps: Whether makepkg should install missing dependencies
        check: Whether to run makepkg's check function
        **file_args: File-managed style arguments (template, context, defaults, etc.)

    Returns:
        Dictionary with keys:
        - success: Boolean indicating if the operation succeeded
        - pkgname: The name of the package
        - message: Human-readable message about the result

    Raises:
        SaltInvocationError: If parameters are invalid
        CommandExecutionError: If makepkg command fails
    """
    # Validate that exactly one of source or upstream_source is provided
    if source and upstream_source:
        raise SaltInvocationError("Cannot specify both 'source' and 'upstream_source'")
    if not source and not upstream_source:
        raise SaltInvocationError("Must specify either 'source' or 'upstream_source'")

    # Get package hint for directory name
    pkg_hint = upstream_source if upstream_source else None

    # Step 0: Create build directory and set permissions
    with _build_directory(keep_builddir, pkg_hint) as tmpdir:
        build_user = __salt__["pacman_build.get_build_user"]()

        if build_user:
            uid = pwd.getpwnam(build_user).pw_uid
            gid = pwd.getpwnam(build_user).pw_gid
            os.chown(tmpdir, uid, gid)
            os.chmod(tmpdir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IROTH | stat.S_IXOTH)

        # Step 1: Read PKGBUILD content
        if source:
            pkgbuild_content = __salt__["salt_file_utils.get_managed_file_content"](
                source=source,
                **file_args
            )
        else:
            # Download from upstream using yay -G
            # Run as build user to avoid yay's root warning
            try:
                build_user = __salt__["pacman_build.get_build_user"]()
                __salt__["cmd.run"](
                    f"yay -G --force {upstream_source}",
                    cwd=tmpdir,
                    runas=build_user
                )
            except CommandExecutionError as e:
                raise SaltInvocationError(f"Failed to download PKGBUILD for {upstream_source}: {e}")

            # yay -G creates a subdirectory with the package name
            pkg_subdir = os.path.join(tmpdir, upstream_source)
            if not os.path.isdir(pkg_subdir):
                raise SaltInvocationError(f"yay -G did not create expected directory {pkg_subdir}")

            # Move all files from subdirectory to tmpdir
            for item in os.listdir(pkg_subdir):
                shutil.move(os.path.join(pkg_subdir, item), tmpdir)
            os.rmdir(pkg_subdir)

            # Read PKGBUILD content
            pkgbuild_path = os.path.join(tmpdir, "PKGBUILD")
            with open(pkgbuild_path, 'r') as f:
                pkgbuild_content = f.read()

        if source:
            # Write PKGBUILD to temp directory
            pkgbuild_path = os.path.join(tmpdir, "PKGBUILD")
            with open(pkgbuild_path, 'w') as f:
                f.write(pkgbuild_content)

        # Step 2: Apply patches
        if patches:
            pkgbuild_path = os.path.join(tmpdir, "PKGBUILD")
            for patch_source in patches:
                # Get patch content
                patch_content = __salt__["salt_file_utils.get_managed_file_content"](
                    source=patch_source,
                    **file_args
                )
                # Write patch to temp file
                patch_path = os.path.join(tmpdir, f"patch_{patches.index(patch_source)}.patch")
                with open(patch_path, 'w') as f:
                    f.write(patch_content)

                # Apply patch
                try:
                    __salt__["cmd.run"](f"patch {pkgbuild_path} < {patch_path}", cwd=tmpdir)
                except CommandExecutionError as e:
                    raise SaltInvocationError(f"Failed to apply patch {patch_source}: {e}")

            # Read the patched PKGBUILD
            with open(pkgbuild_path, 'r') as f:
                pkgbuild_content = f.read()

        # Step 3: Get metadata from PKGBUILD
        pkgname = _parse_pkgbuild_name(pkgbuild_content)
        if not pkgname:
            raise SaltInvocationError("Could not parse package name from PKGBUILD")

        # Step 4: Check if already installed
        try:
            __salt__["pacman_build.run_cmd"](f"pacman --query --info {pkgname}")
            return {
                "success": True,
                "pkgname": pkgname,
                "message": f"Package {pkgname} is already installed"
            }
        except CommandExecutionError:
            pass

        # Build makepkg command
        makepkg_args = ["makepkg", "--noconfirm", "--install"]
        if install_deps:
            makepkg_args.append("--syncdeps")
        if not check:
            makepkg_args.append("--nocheck")

        # Set ownership on all files
        if build_user:
            __salt__["cmd.run"](f"chown -R {build_user}:{build_user} {tmpdir}")

        # Run makepkg
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
