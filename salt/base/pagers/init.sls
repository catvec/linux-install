# Installs Pagers
pagers_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.pagers.multipkgs }}
