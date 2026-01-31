partitions:
  # Boot partition
  boot:
    # Device name
    name: /dev/nvme0n1p1

    # UUID
    uuid: E082-40D5

    # Mountpoint
    mountpoint: /boot

    # File system type
    filesystem_type: vfat

    # Device mount options
    mount_options: rw,relatime

    # Dump mount option
    mount_option_dump: 0

    # Pass mount option
    mount_option_pass: 2

  # Root partition
  root:
    # Device name
    name: /dev/nvme0n1p4

    # UUID
    uuid: 6b445f6f-11a5-4b42-82fc-b4f014919b5c
    luks_uuid: e8d7c689-8324-4bca-8c10-65a03b7afbb6

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
    uuid: 03ddaaa4-37c7-43da-8976-1acd118e7ec7

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
