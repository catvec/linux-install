zfs:
  multipkgs:
    - aurpkg:
        - zfs-dkms
        - zfs-utils

  services:
    - zfs.target
    - zfs-import.target
    - zfs-import-cache.service
