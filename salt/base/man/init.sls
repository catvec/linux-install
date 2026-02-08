# Installs Sets up man pages
man_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.man.multipkgs }}
