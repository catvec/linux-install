# Installs HDDTemp, an HDD temperature monitoring tool
hddtemp_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.hddtemp.multipkgs }}
