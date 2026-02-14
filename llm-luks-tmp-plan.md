# TPM-Based LUKS Auto-Unlock for benito

## Context

The benito Arch Linux system currently has a LUKS-encrypted root partition but requires manual password entry at boot. This plan enables automatic unlocking using TPM2, with Secure Boot as the trusted root.

**How it works:**
- systemd-cryptenroll creates a key derived from the LUKS volume and binds it to TPM2 PCR 7 (Secure Boot state)
- During boot, systemd in initramfs asks the TPM to release the key
- TPM only releases if Secure Boot is intact and PCR 7 matches expected values
- A recovery key is created as backup if TPM/Secure Boot fails

## Prerequisites

1. TPM 2.0 must be enabled in BIOS (verified via `bootctl` - "TPM2 Support: yes")
2. Systemd 248+ (standard on Arch)
3. Secure Boot must be enabled

## Implementation Plan

### Directory Structure
Following the repository pattern:
- `pillar/base/` - Shared pillar data (not environment-specific)
- `salt/base/` - Shared salt states (not environment-specific)
- `pillar/arch/` - Arch-specific pillar data only
- `salt/arch/` - Arch-specific salt states only

### One-Time Manual Steps (document in `/etc/linux-install/USER-INSTRUCTIONS.md`)

These steps must be done manually once after the base system is installed:

1. **Enable Secure Boot in BIOS** (hardware-dependent - reboot and configure)

2. **Install sbctl and generate Secure Boot keys:**
   ```bash
   pacman -S sbctl
   sbctl generate-keys
   sbctl enroll-keys --microsoft
   sbctl status  # Verify "Secure Boot is enabled"
   ```

3. **Install TPM tools and enroll LUKS volume:**
   ```bash
   pacman -S tpm2-tools tpm2-tss
   # Get LUKS device from pillar.partitions.root.name (e.g., /dev/nvme0n1p2)
   systemd-cryptenroll --recovery-key /dev/nvme0n1p2
   systemd-cryptenroll --wipe-slot=empty --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
   ```

4. **Verify enrollment and rebuild initramfs:**
   ```bash
   systemd-cryptenroll --list /dev/nvme0n1p2
   mkinitcpio -P
   ```

5. **Reboot to test** - System should auto-unlock with Secure Boot enabled

### Important Notes

- **If enrollment fails**: Check that Secure Boot is enabled (`sbctl status`)
- **If locked out**: Use the recovery key saved to `/root/luks-recovery-key.txt`
- **PCR 7 binding**: TPM only releases key if Secure Boot state matches; flashing firmware or changing SB keys may break auto-unlock

### Salt Automation (for idempotent verification, not auto-enrollment)

The Salt states will **verify** that TPM and Secure Boot are properly configured and **FAIL** if not enrolled/enabled. This ensures the user is alerted if they haven't completed the manual steps.

#### 1. TPM Pillar (Base)

**New Pillar:** `/etc/linux-install/pillar/base/tpm/init.sls`
```yaml
tpm:
  pkgs:
    - tpm2-tools
    - tpm2-tss
  cryptenroll:
    luks_device_key: root  # Reference to pillar.partitions.root.name
    recovery_key_path: /root/luks-recovery-key.txt
```

#### 2. TPM Salt State (Base)

**New State:** `/etc/linux-install/salt/base/tpm/init.sls`
- Install tpm2-tools and tpm2-tss packages
- Check if TPM is enrolled (idempotent check via `systemd-cryptenroll --list`)
- **FAIL if not enrolled** - alert user to run manual enrollment steps
- Recovery key path from pillar (for documentation in error message)

#### 3. Secure Boot Pillar (Base)

**New Pillar:** `/etc/linux-install/pillar/base/sbctl/init.sls`
```yaml
sbctl:
  pkgs:
    - sbctl
  key_dir: /etc/secureboot
```

#### 4. Secure Boot Salt State (Base)

**New State:** `/etc/linux-install/salt/base/sbctl/init.sls`
- Install sbctl package
- Check if Secure Boot is enabled via `sbctl status`
- **FAIL if not enabled** - alert user to run manual sbctl setup steps

#### 5. Initramfs Update (Arch-specific)

**Modified:** `/etc/linux-install/pillar/arch/kernel/benito.sls`
- Add `tpm2` hook to mkinitcpio hooks list
- This ensures tpm2-tools are available during early boot

#### 6. Top File (Arch-specific)

**Modified:** `/etc/linux-install/salt/arch/top.sls`
- Add sbctl and tpm states to benito's state list
- Order: sbctl and tpm must run before kernel states

## Files to Create/Modify

| Action | File |
|--------|------|
| Create | `/etc/linux-install/pillar/base/tpm/init.sls` |
| Create | `/etc/linux-install/salt/base/tpm/init.sls` |
| Create | `/etc/linux-install/pillar/base/sbctl/init.sls` |
| Create | `/etc/linux-install/salt/base/sbctl/init.sls` |
| Modify | `/etc/linux-install/pillar/arch/kernel/benito.sls` |
| Modify | `/etc/linux-install/salt/arch/top.sls` |

## Plan for USER-INSTRUCTIONS.md additions

Add a new section after "Bootstrap A Working Environment" about TPM-based auto-unlock:

```markdown
## Enable TPM-Based LUKS Auto-Unlock

To enable automatic unlocking of your LUKS partition using TPM2:

1. **Enable Secure Boot in BIOS** (requires reboot)

2. **Install sbctl and generate keys:**
   ```bash
   pacman -S sbctl
   sbctl generate-keys
   sbctl enroll-keys --microsoft
   sbctl status  # Verify "Secure Boot is enabled"
   ```

3. **Install TPM tools and enroll LUKS:**
   ```bash
   pacman -S tpm2-tools tpm2-tss
   # Get LUKS device from pillar.partitions.root.name
   systemd-cryptenroll --recovery-key /dev/nvme0n1p2
   systemd-cryptenroll --wipe-slot=empty --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
   ```

4. **Verify and rebuild:**
   ```bash
   systemd-cryptenroll --list /dev/nvme0n1p2
   mkinitcpio -P
   ```

5. **Reboot to test** - System should auto-unlock with Secure Boot enabled

### Troubleshooting

- **If enrollment fails**: Check that Secure Boot is enabled (`sbctl status`)
- **If locked out**: Use the recovery key saved to `/root/luks-recovery-key.txt`
- **PCR 7 binding**: TPM only releases key if Secure Boot state matches; flashing firmware or changing SB keys may break auto-unlock
```

## Testing

1. **Dry-run:** `salt-apply -t -s sbctl` then `salt-apply -t -s tpm`
2. **Check TPM:** `ssh benito tpm2_getcap tpm2`
3. **Verify enrollment:** `ssh benito systemd-cryptenroll --list /dev/nvme0n1p2`
4. **Reboot test:** System should auto-unlock with Secure Boot enabled

## Recovery

If Secure Boot/TPM fails:
- Recovery key is saved to `/root/luks-recovery-key.txt`
- Boot with recovery key at LUKS prompt
- To flush TPM enrollment: `systemd-cryptenroll --flush /dev/nvme0n1p2`