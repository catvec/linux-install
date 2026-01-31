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
    uuid: 0468ea76-879d-435e-bd78-bc34ad71db91
    luks_uuid: c5e825f1-b504-4f3d-80bd-16445bdd3f7b

    # Mountpoint
    mountpoint: /

    # File system type
    filesystem_type: ext4

    # Device mount options
    mount_options: defaults

    # Dump mount option
    mount_option_dump: 0

    # Pass mount option
    mount_option_pass: 0

  # Swap partition
  swap:
    name: /dev/nvme0n1p4
    uuid: dc81488a-cae7-40ef-9dd4-d9586ef14419
