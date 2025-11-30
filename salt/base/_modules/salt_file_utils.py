"""
Utility functions for file handling in Salt modules.

This module provides common file operations like retrieving and rendering
files from salt:// URIs, following Salt's standard patterns.
"""
from typing import Optional, Dict, Any
import logging

from salt.exceptions import SaltInvocationError
from salt_types import FileManagedArgs

log = logging.getLogger(__name__)


def extract_file_managed_args(**kwargs) -> FileManagedArgs:
    """Extract file.managed-style arguments from kwargs.

    This helper extracts known file.managed arguments and returns them
    as a FileManagedArgs dict, leaving other kwargs untouched.

    Arguments:
        **kwargs: Keyword arguments that may contain file.managed args

    Returns:
        Dictionary containing only the file.managed arguments
    """
    file_args: FileManagedArgs = {}

    if "source" in kwargs:
        file_args["source"] = kwargs["source"]
    if "template" in kwargs:
        file_args["template"] = kwargs["template"]
    if "context" in kwargs:
        file_args["context"] = kwargs["context"]
    if "defaults" in kwargs:
        file_args["defaults"] = kwargs["defaults"]
    if "saltenv" in kwargs:
        file_args["saltenv"] = kwargs["saltenv"]

    return file_args


def get_managed_file_content(
    source: str,
    template: Optional[str] = None,
    context: Optional[dict] = None,
    defaults: Optional[dict] = None,
    **kwargs
) -> str:
    """Get file contents from a source, with optional template rendering.

    This follows the same pattern as file.managed for the source and template parameters.

    Arguments:
        source: File source (salt://, http://, or local path)
        template: Template engine to use (e.g., 'jinja', 'mako'). None for no templating.
        context: Dictionary of variables to pass to the template
        defaults: Dictionary of default values for template variables
        **kwargs: Additional arguments

    Returns:
        The file contents (rendered if template is specified)

    Raises:
        SaltInvocationError: If the file cannot be retrieved or rendered
    """
    if context is None:
        context = {}
    if defaults is None:
        defaults = {}

    # Merge defaults and context
    template_vars = {}
    template_vars.update(defaults)
    template_vars.update(context)

    try:
        if template:
            # Use Salt's template rendering
            # First cache the file
            cached_path = __salt__["cp.cache_file"](source)
            if not cached_path:
                raise SaltInvocationError(f"Failed to cache file: {source}")

            # Render the template
            rendered = __salt__["slsutil.renderer"](
                path=cached_path,
                default_renderer=template,
                **template_vars
            )
            return rendered
        else:
            # Get raw file contents
            content = __salt__["cp.get_file_str"](source)
            if content is False:
                raise SaltInvocationError(f"Failed to retrieve file: {source}")
            return content
    except Exception as e:
        raise SaltInvocationError(f"Error retrieving/rendering {source}: {e}")
