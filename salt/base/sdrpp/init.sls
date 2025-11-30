# Installs SDR++ (SDR GUI)
sdrpp_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.sdrpp.multipkgs }}
