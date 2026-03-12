# Installs OpenZFS
zfs_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.zfs.multipkgs }}
