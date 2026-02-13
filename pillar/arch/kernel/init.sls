kernel:
  # Package which installs Kernel
  kernel_pkg: linux

  # Modprobe directory
  modprobe_dir: /etc/modprobe.d/

  # Vconsole configuration file, used during boot
  vconsole_conf_file: /etc/vconsole.conf

  # Initramfs builder configuration
  mkinitcpio:
    conf_path: /etc/mkinitcpio.conf

    hooks: "base systemd autodetect modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck"
    
