# Installs Fingerprint GUI, a fprintd GUI
fingerprint_gui_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.fingerprint_gui.multipkgs }}
