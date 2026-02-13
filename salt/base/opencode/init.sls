# Installs OpenCode, an open source agent coding CLI (https://github.com/anomalyco/opencode)
opencode_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.opencode.multipkgs }}
