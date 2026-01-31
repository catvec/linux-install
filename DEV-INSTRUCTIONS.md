# Developer Instructions
Documentation aimed at developers of this repository.

# Table Of Contents
- [Overview](#overview)
- [Directories](#directories)
- [Bootstrap Process](#bootstrap-process)
- [Salt Environments](#salt-environments)

# Overview
This repository contains configuration as code which sets up my Linux 
environment. This configuration is for a tool named 
[Salt](https://www.saltstack.com/) which handles almost all aspects of system
configuration. With the exception of the very first boot where Salt
must be installed and the general environment must be bootstrapped.

Multiple computers of mine use the configuration in this repository. 
[Salt Environments](#salt-environments) are used to pick and customize what
pieces of configuration are setup on each system. 

# Directories
- **live-scripts**: Scripts for installing Void linux
- **setup-scripts**: Scripts for setting up the installation process
- **salt**: Salt states for Void installation
- **pillar**: Salt pillars for Void installation
- **screenshots**

# Bootstrap Process
The configuration of my Linux environment is almost entirely automated using
Salt. This is with the exception of the base Linux installation. A set of 
special Bash scripts are used to install Linux onto the system from a Live USB
and then invoke Salt to do the rest.

At a high level the process works like so:

- The `setup-scripts/mk-iso.sh` script is used to create a special ISO.
  - The ISO has this Git repository included in the `/etc/linux-install` path. 
  - A few tools like Git and Salt are also installed to aid in the 
    setup process.
- The `setup-scripts/mk-install-media.sh` script is used to create an boot-able
  live USB from the ISO.
- The user boots from this USB drive.
- The user runs `live-scripts/cryptsetup.sh` to setup full disk encryption.
- The user runs `live-scripts/install.sh` which configures and then runs Salt.
  - This script installs the `base-system` XBPS package onto the root file 
	partition. Additionally it copies a few essential configuration files over
	from the live USB.
  - The `live-scripts/setup.sh` script is automatically invoked in a chroot jail
	in the root file partition.
    - This script automatically runs `live-scripts/link-salt-dirs.sh` which 
	  creates symbolic links for the Salt state and pillar files to the `/srv/`
	  directory where Salt excepts them.
	- Then a Salt minion configuration file is setup on the root file partition.
	- Finally the Salt high state is run on the root file partition.
	
The above process is almost entirely automated, and completely installs Linux
and configures it with Salt.

# Salt Environments
Salt provides environments for the purpose of using the same configuration files
over multiple computers. This system recognizes that small details may need to 
be tweaked from environment to environment.

The `base` environment contains all the main configuration files. All other 
environments simply extend this `base` environment.

## Salt Environment Flag File
The `/etc/linux-install/environment-flag` file indicates what environment is 
currently being used. This is created by the `install.sh` file.

This flag file will only be used by scripts the user may run **after** the 
bootstrap process has been completed. Never by any scripts in the
`live-scripts/` and `setup-scripts/` directories. Currently this is only the
`salt-apply` script.

## Creating a Salt Environment
Salt environments are made up of the following:

- A folder with the name of the environment in the `salt` and 
  `pillar` directories
- Configuration for the Salt minions to recognize the new environment

Follow the instructions below:

1. Pick an environment name, any time you see `REPLACE_ME_ENV` in the 
   instructions below substitute the name with which you just came up.
2. Make the environment state and pillar directories:
   ```
   % mkdir -p {salt,pillar}/REPLACE_ME_ENV
   ```
3. Copy the pillar stack file:
   ```
   % cp pillar/base/pillar-stack.cfg pillar/REPLACE_ME_ENV
   ```
4. Create the `environment` pillar. First create a file to hold the 
   pillar's value:
   
   ```
   % echo "environment: REPLACE_ME_ENV" > pillar/REPLACE_ME_ENV/environment.sls
   ```
   
   Next create a top file which only includes this pillar named 
   `pillar/REPLACE_ME_ENV/top.sls` with the contents:
   
   ```
   REPLACE_ME_ENV:
     '*':
	   - environment
   ```
5. Add the environment to the `salt-configuration` pillar by editing the
   `pillar/base/salt-configuration/init.sls` file with the following:
   ```yaml
   salt_configuration:
     # ...
	 state_dirs:
	   # ...
	   REPLACE_ME_ENV:
	     public: {{ content_root }}/salt/REPLACE_ME_ENV
	 
	 # ...
	 pillar_dirs:
	   REPLACE_ME_ENV:
	     public: {{ content_root }}/pillar/REPLACE_ME_ENV
	 
	 # ...
	 pillar_stack:
	   # ...
	   REPLACE_ME_ENV:
	     public: {{ content_root }}/pillar/REPLACE_ME_ENV/pillar-stack.cfg
   ```
6. Add the environment to the Salt minion's configuration by editing
   the `salt/base/salt-configuration/minion` file with the following:
   ```yaml
   # ...
   file_roots:
     # ...
     REPLACE_ME_ENV:
       - {{ pillar.salt_configuration.state_dirs.REPLACE_ME_ENV.public }}
       - {{ pillar.salt_configuration.state_dirs.base.public }}
       - {{ pillar.salt_configuration.state_dirs.base.secret }}
	   
   # ...
   pillar_roots:
     # ...
     REPLACE_ME_ENV:
       - {{ pillar.salt_configuration.pillar_dirs.REPLACE_ME_ENV.public }}
	   
   # ...
   ext_pillar:
     - stack:
         pillar:environment:
           # ...
           REPLACE_ME_ENV:
             - {{ pillar.salt_configuration.pillar_stack.base.public }}
             - {{ pillar.salt_configuration.pillar_stack.base.secret }}
             - {{ pillar.salt_configuration.pillar_stack.REPLACE_ME_ENV.public }}
   ```
7. Add the environment to the `live-scripts/link-salt-dirs.sh` script by adding:
   ```bash
   # ...
   salt_state_links=(
       # ...
       "$repo_dir/salt/REPLACE_ME_ENV:$salt_content_dir/salt/REPLACE_ME_ENV
	   # ...
   )
   
   salt_pillar_links=(
       # ...
	   "$repo_dir/pillar/REPLACE_ME_ENV:$salt_content_dir/pillar/REPLACE_ME_ENV
	   # ...
   )
   ```
8. Create a Salt top file named `salt/REPLACE_ME_ENV/top.sls` with the content:
   ```
   REPLACE_ME_ENV:
     '*':
	   # Salt configuration
       - salt-configuration
     
	   - Now put a list of every salt state you want here
   ```

## Host Dependant Pillars
Each pillar directory for a salt environment has a `pillar-stack.cfg` file in it. This configures salt's `ext_pillar` module, telling it which pillars to read for the current host.

There are 2 main setups which can be used here:

- Read all pillars for all hosts.  
  To configure this behavior simply put the following in the pillar stack file:
  ```
  */*
  ```
- Common pillars, with host specific values:
  This setup allows one salt environment to have different values depending on the host salt is running on.
  
  Pillar files with the name `init.sls` will be loaded on any host.  
  Pillar files with the name `<hostname>.sls` (where `<hostname>` is the host's hostname) will only be loaded on matching hosts.
  
  To configure this behavior put the following in the pillar stack file:
  ```
  */init.sls
  */{{ __grains__["id"] }}.sls
  ```
