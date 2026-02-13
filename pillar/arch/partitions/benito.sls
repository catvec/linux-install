partitions:
  # Boot partition
  boot:
    # Device name
    name: /dev/nvme0n1p1

    # UUID
    uuid: 4A71-F88F

    # Mountpoint
    mountpoint: /boot

    # File system type
    filesystem_type: vfat

    # Device mount options
    mount_options: rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro

    # Dump mount option
    mount_option_dump: 0

    # Pass mount option
    mount_option_pass: 2

  # Root partition
  root:
    # Device name
    name: /dev/nvme0n1p3

    # UUID
    uuid: c804d8e7-bf26-4614-afb6-2b496e2631f7
    luks_uuid: bef20ee3-ad89-4d66-899c-8fb4abdccae8

    # Mountpoint
    mountpoint: /

    # File system type
    filesystem_type: ext4

    # Device mount options
    mount_options: defaults

    # Dump mount option
    mount_option_dump: 0

    # Pass mount option
    mount_option_pass: 1

  # Swap partition
  swap:
    # Name of device
    name: /dev/nvme0n1p2

    # Partition UUID
    uuid: 1c06bb6a-f452-4f79-bdf7-89f838bcb04b

    # Mount point
    mountpoint: none

    # File system type
    filesystem_type: swap

    # Device mount options
    mount_options: defaults

    # Dump mount option
    mount_option_dump: 0

    # Pass mount option
    mount_option_pass: 0
