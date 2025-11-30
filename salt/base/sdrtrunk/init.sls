# Installs SDRTrunk (https://github.com/DSheirer/sdrtrunk)
sdrtrunk_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.sdrtrunk.multipkgs }}
