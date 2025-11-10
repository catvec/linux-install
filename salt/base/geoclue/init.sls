# Installs Geoclue a desktop geo location service
geoclue_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.geoclue.multipkgs }}

{{ pillar.geoclue.beacondb_conf }}:
  file.managed:
    - source: salt://geoclue/99-beacondb.conf
