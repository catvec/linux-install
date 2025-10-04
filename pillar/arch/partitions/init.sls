partitions:
  # Boot partition
  boot:
    # Device name
    name: /dev/nvme0n1p1

    # UUID
    uuid: A2DA-6768

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
    name: /dev/nvme0n1p2

    # UUID
    part_uuid: 5c00e106-f99f-4bb7-936b-ce31fb8b947c
    luks_uuid: 6a7fc498-f8a1-44bf-8960-46302e417b7a

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
    name: /dev/nvme0n1p5

    # Partition UUID
    uuid: 0667db83-8185-4024-8893-f6520a86bd8d

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
