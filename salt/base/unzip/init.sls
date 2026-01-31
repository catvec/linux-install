# Installs Unzip
unzip_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.unzip.multipkgs }}
