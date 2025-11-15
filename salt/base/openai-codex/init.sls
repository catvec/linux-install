# Installs openai-codex
openai_codex_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.openai_codex.multipkgs }}
