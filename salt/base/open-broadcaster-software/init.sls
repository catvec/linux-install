# Installs Open Broadcaster Software

open_broadcaster_software_multipkgs:
  multipkg.installed:
    - pkgs: {{ pillar.open_broadcaster_software.multipkgs }}
