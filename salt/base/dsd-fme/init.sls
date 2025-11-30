# Installs DSD-FME (DSD Florida Man Edition)
dsd_fme_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.dsd_fme.multipkgs }}
