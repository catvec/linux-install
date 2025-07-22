# Installs Installs the Claude Code agent CLI
claude_code_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.claude_code.multipkgs }}
