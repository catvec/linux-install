# Installs Caffeinate (Utility which prevents compute from falling asleep)
caffeinate_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.caffeinate.multipkgs }}
