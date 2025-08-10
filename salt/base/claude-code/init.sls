# Installs the Claude Code agent CLI
claude_code_pkgs:
  npm.installed:
    - pkgs: {{ pillar.claude_code.pkgs }}
