# Installs Screenkey, a key input visualizer
screenkey_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.screenkey.multipkgs }}
