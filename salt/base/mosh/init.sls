# Installs Mosh - mobile shell
mosh_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.mosh.multipkgs }}
