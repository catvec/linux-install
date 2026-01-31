# User Instructions
Linux installation instructions for end users.

# Table Of Contents
- [Setup](#setup)

# Setup
Install the setup instructions for your particular Linux distribution.

## Setup Encrypted Partition
Run:

```
# /etc/linux-install/live-scripts/crypsetup.sh -p ROOT_PARTITION -c cryptroot
# or if your live install ISO was not built with this repo's contents:
# cryptsetup -v luksFormat ROOT_PARTITION
# cryptsetup open ROOT_PARITITION cryptroot
# mkfs.ext4 /dev/mapper/cryptroot
```

## Download Linux Install Repository
1. Clone this repository to the `/etc/linux-install/` directory
  - Make sure to run `git submodule update --init` to initialize and download submodules
2. Run the [`setup-scripts/install-salt.sh`](./setup-scripts/install-salt.sh) script to install Salt using the [Onedir strategy](https://docs.saltproject.io/salt/install-guide/en/latest/topics/upgrade-to-onedir.html)
3. Run the `live-scripts/link-salt-dirs.sh` to make symlinks to the `/srv/{salt,pillar}` directory
4. Copy `salt/base/salt-configuration/minion.templated` to `/etc/salt/minion/` (This contains the most recently created minion config file from another machine, making initial bootstrapping easier)
5. Write your salt environment's name to `/etc/linux-install/environment-flag`
6. Register this repository's custom Salt modules:
   ```bash
   salt-call --local saltutil.sync_all
   ```

# Bootstrap A Working Environment
From here you should be able to run `salt-call --local state.apply ...` to run any other salt states. To bootstrap the rest of the system run the following:

Install the `salt-apply-script` helper to make the commands after this one easier and shorter
```bash
salt-call --local state.apply salt-apply-script
```

Then install the following salt states in this order using `salt-apply -s <NAME>`:

- `pacman`
- `users`
- `sudo`
- `ssh`
- `git`
- `bash`
- `which`
- `c`
- `cmake`
- `shell-profile`
- `emacs`
- `x11`
- `xorg`
- `rice`
- `i3`
- `display-manager`
- `kitty`

At this point stop and fill in the pillar values for the `partitions` state. Then apply `partitions`.

At this point you should now have user accounts and a visual interface. From which you can continue applying other states you need.

# Tips and Tricks
Some helper ideas that will improve ease of setup:

## Make An Initial SSH Key
It is a lot easier to clone down the Linux Install repo if you have an SSH key (so the secrets/ submodule can be cloned too).

1. Make sure `git` and OpenSSH is installed
2. Generate a temporary SSH key:
   ```bash
   ssh-keygen -t ed25519
   ```
   It is easiest if you don't use a password for this key.  
   
   Send the public key to another working computer using instructions in [Sending Data Between Devices](#sending-data-between-devices)
   
Be sure to delete it from GitHub after you have bootstrapped.

## Sending Data Between Devices
- Run a netcat server on another already set up machine on the same network to transfer files (for example to add the new machine's SSH key to GitHub):
  - On your already setup machine:
    - Get it's IP address with `ip addr show`
    - Start the netcat server:
     ```bash
     nc -l -p 9999
     ```
  - On the new machine send any data to the `nc <other machine ip> 9999` command and it should appear in your existing machine's terminal (Arch linux Netcat package is `netcat`)

## Keyboard Dropping Or Repeating Keys
Sometimes when booting into the live installation ISO your keyboard will act weird. My hypothesis is at boot time the keyboard was registered using a more primitive driver. To fix this: after you have booted into the live install ISO simply disconnect and reconnect your keyboard. This may help the system register the keyboard with a more correct driver.

## Manual Hacks
Some user guide information about manual settings which might need to be changed can be found in [`USER-PROGRAMS-HELP.md`](./USER-PROGRAMS-HELP.md).
