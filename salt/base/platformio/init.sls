# Installs the PlatformIO embedded development toolkit (https://platformio.org/)
platformio_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.platformio.multipkgs }}
