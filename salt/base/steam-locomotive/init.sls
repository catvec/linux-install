# Installs Installs the sl utility
steam_locomotive_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.steam_locomotive.multipkgs }}
