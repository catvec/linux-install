# Installs Installs hut, the sourcehut CLI
sourcehut_cli_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.sourcehut_cli.multipkgs }}
