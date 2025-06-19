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
```

## Download Linux Install Repository
1. Clone this repository to the `/etc/linux-install/` directory
2. Run the [`setup-scripts/install-salt.sh`](./setup-scripts/install-salt.sh) script to install Salt using the [Onedir strategy](https://docs.saltproject.io/salt/install-guide/en/latest/topics/upgrade-to-onedir.html)
3. Run the `live-scripts/link-salt-dirs.sh` to make symlinks to the `/srv/{salt,pillar}` directory
4. Copy `salt/base/salt-configuration/minion` to `/etc/salt/minion/` and manually substitute the Jinja syntax
5. Run the `setup-scripts/make-salt-venv.sh` script to install Salt
6. Run `salt-call --local state.apply salt-configuration`

## Manual Hacks
Some user guide information about manual settings which might need to be changed can be found in [`USER-PROGRAMS-HELP.md`][./USER-PROGRAMS-HELP.md].
