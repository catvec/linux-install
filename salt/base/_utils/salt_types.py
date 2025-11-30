"""
Shared type definitions for Salt states and modules.

This module provides common TypedDict definitions used across custom Salt states and execution modules.
"""
from typing import Optional, TypedDict, Union, Dict, Any


class SaltStateResChanges(TypedDict):
    """Describes changes made by a Salt state.

    Fields:
    - old: User-facing string describing previous status before changes
    - new: User-facing string describing status after changes
    """
    old: str
    new: str


class SaltStateRes(TypedDict):
    """Describes the result of a salt state execution.

    Fields:
    - name: Identifier of state block
    - result: Indicates if the state was successful (True), failed (False), or shouldn't run (None)
             See: https://docs.saltproject.io/en/latest/ref/states/writing.html#return-data
    - changes: Describes what changed due to this state running
               SaltStateResChanges if changes were made, empty dict if no changes
    - comment: Single line describing what changed
    """
    name: str
    result: Optional[bool]
    changes: Union[SaltStateResChanges, Dict[str, str]]
    comment: str


class FileManagedArgs(TypedDict, total=False):
    """Arguments for file.managed-style file handling.

    All fields are optional to support partial specification.
    Used with **kwargs unpacking to avoid repeating these parameters.
    """
    source: Optional[str]
    template: Optional[str]
    context: Optional[Dict[str, Any]]
    defaults: Optional[Dict[str, Any]]
    saltenv: str
