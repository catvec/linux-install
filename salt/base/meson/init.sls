# Installs Menson build tool (https://mesonbuild.com/)
menson_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.menson.multipkgs }}
