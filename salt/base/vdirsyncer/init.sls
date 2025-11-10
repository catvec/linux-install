# Installs vdirsyncer (https://vdirsyncer.pimutils.org/) a calendar sync utility
vdirsyncer_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.vdirsyncer.multipkgs }}
