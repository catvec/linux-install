# Installs KDEConnect, a phone to laptop bridge
kdeconnect_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.kdeconnect.multipkgs }}
