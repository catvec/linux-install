# Sets up parts of secure boot
# Since this is such a sensitive operation which has the ability to brick booting some actions need to be performed manually. In addition some actions require rebooting into the system setup utility (sometimes called BIOS setup, but a misnomer in our case bc secure boot uses UEFI)
# See USER-INSTRUCTIONS.md#secure-boot
secure_boot_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.secure_boot.multipkgs }}
