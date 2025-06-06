base:
  '*':
    # Salt configuration
    - salt-configuration

    # Base system configuration
    - kernel
    - cleanup-kernel
    - exfat
    - ntfs
    - initramfs
    - bootloader
    - fstab
    - pam

    # Higher level system configuration
    - system-configuration
    - hostname
    - syslog
    - internet
    - xbps-configuration
    - ntp
    - touchpad
    - audio
    - backlight
    - bluetooth
    - paprefs
    - fingerprint-reader
    - local-dns
    - external-display
    - power-management
    - dbus
    - printers
    - vulkan

    # User configuration
    - bash
    - zsh

    - users
    - shell-profile

    - sudoers
    - linux-install-repo
    - home-directories
    - user-services

    # Development environment configuration
    - build-deps
    - emacs
    - tmux
    - scripts-repo
    - salt-apply-script
    - c
    - lldb
    - cmake
    - automake
    - pkg-config
    - go
    - python
    - elixir
    - nodejs
    - rust
    - haskell
    - wasmtime
    - aws-cli
    - digitalocean-cli
    - google-cloud-sdk
    - red-hat-vpn
    - aws-key-pairs
    - openshift-client
    - java
    #- android-sdk # Has redundant updates rn, takes too long, disabled for now (issue 12)
    - flutter
    - argo
    - ngrok
    - operator-sdk
    - mbed
    - particle
    - dfu-util
    - kustomize
    - gatsby-cli
    - xlibs
    - typescript
    - eclipse
    - deno
    - heroku
    - velociraptor
    - denopack
    - denon
    - asar
    - p7zip
    - perf-tool
    - firebase
    - nestjs-cli
    - typeorm
    - arduino
    - mdns
    - shellcheck
    - dotnet

    # General tools configuration
    - utilities
    - trash-cli
    - flatpak
    - gpg
    - git
    - subversion
    - mercurial
    - ssh
    - vsv
    - checkforupdates
    - wireguard
#    - lock-script
    - kube-namespace
    - network-utils
    - vault
    - containers
    - freetype
    - expat
    - ncdu
    - software-defined-radio
    - sl
    - libguestfs
    - gohls
    - ffmpeg
    - transmission-torrent
    - the-silver-searcher
    - dhcp-server
    - gnome-keyring
    - ps-tools
    - atop
    - go-wails

    # User interface configuration
    - xorg
    - wayland
    - start-wayland-script
    - sway
    - sway-launcher-desktop
    - i3
    - alacritty
    - compton
    - dunst
    - polybar
    - rice
    - fonts
    - wmctrl
    - sshfs
 
    # Applications configuration
    - misc-applications
    - gimp
    - firefox
    - slack
    - weechat
    - blender
    - godot
    - omnisharp
    - logisim
    - wireshark
    - tor
    - steam
    - chrome
    - cool-retro-term
    - open-broadcaster-software
    - libre-office
    - minecraft
    - pirate-get
    - kodi
    - graphviz
    - pv
    - signal
    - dolphin-emu
    - vscode
    - rpi-imager
    - gotify-client
    - qmk

    # Applications which must be manually built and installed
    - manual-void-pkgs
