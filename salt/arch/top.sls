arch:
  '*':
    # Salt configuration
    - salt-configuration
    - salt-virtual-environment

    # Base system configuration
    - kernel
    - fstab
    - firmware
    - bootloader

    # Higher level configuration
    - hostname
    - ntp
    - timezone
    - internet
    - ntfs
    - exfat
    - audio
    - yay
    - network-utils
    - backlight
    - hibernation
    #- thunderbolt
    #- pam
    - polkit
    - fonts
    #- firewall
    #- power-management
    - bluetooth
    - display-manager
    - wireguard
    - fingerprint-reader
    - fingerprint-gui
    - printers
    
    # User configuration
    - users
    - sudoers

    - home-directories
    
    - bash
    - which
    - shell-profile
    - pacman

    #- user-service-manager
    #- xdg-autostart

    # Development environment configuration
    - ssh
    - git
    - salt-apply-script
    - alacritty
    - kitty
    - c
    - cmake
    - meson
    - uv
    - shellcheck
    - screen
    - kubectl
    #- ncdu
    - containers
    - go
    - flutter
    - terraform
    - tflint
    - infracost
    #- software-defined-radio
    - digitalocean-cli
    - godot
    #- dotnet
    #- ceph-client
    - dig
    - nmap
    - netcat
    - telnet
    #- insomnia
    - python
    - pipenv
    - aws-cli
    #- eksctl
    - java
    - android-sdk
    - apktool
    - salt-lint
    - jq
    - yq
    - gtk-dev
    - unreal-engine
    - httpie
    - s3cmd
    - wireshark
    - hugo
    - arduino
    - latex
    - talosctl
    - ipmitool
    - icedtea-web
    - buffalo
    - platformio
    - rsync
    - downgrade
    - xxd
    - kubectx
    - nx
    - gemini-cli
    - claude-code
    - qwen-code
    - vagrant
    - mkcert
    - libfreenect
    - caffeinate
    - fedify
    - deno
    - openai-codex
    - tree
    - cables

    # General tools configuration
    - gpg
    - trash-cli
    - htop
    - flatpak
    - flameshot
    - spell-check
    - qt
    - pkgfile
    - ncdu
    - modeprobed-db
    
    # User interface configuration
    - vulkan
    - wayland
    - xdg-desktop-portal
    - start-wayland-script
    - x11
    - xorg
    - wl-snip
    - rice
    - sway
    - hyprland
    - scrot
    - i3
    - gnome-keyring

    # Applications configuration
    #- links
    - firefox
    - geoclue # (Firefox geolocation)
    - avahi
    - librewolf
    - chrome
    - syncthing
    - blender
    #- emacs
    - doom-emacs
    - vscode
    - cursor-editor
    - signal
    - gimp
    - discord
    - openvpn
    - qbittorrent
    - k3s
    #- gnucash
    - youtube-dl
    - open-broadcaster-software
    - steam
    - steam-link
    #- tailscale
    - file-manager
    - ngrok
    - inkscape
    - vlc
    - mpv
    - anki
    - qgis
    - jetbrains
    - hidclient
    - go-swagger
    - openapi-generator
    - zoom
    - qemu
    - gns3
    - virtualbox
    - 7zip
    - rpi-imager
    - cockatrice
    - wine
    - ipmiview
    - iperf
    - software-defined-radio
    - chirp
    - gthumb
    - korganizer
    - evolution
    - strawberry-music-organizer
    - gpodder
    - libre-office
    - vdirsyncer
    - ollama
    - sdrtrunk
    - sdrpp
    - dsd-fme
