kernel:
  # Initramfs builder configuration
  mkinitcpio:
    hooks: "base systemd autodetect microcode modconf kms keyboard keymap sd-vconsole block sd-encrypt filesystems fsck"
