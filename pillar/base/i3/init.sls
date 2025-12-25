{% set scripts_dir = '/opt/i3/scripts' %}

i3:
  # i3 related packages
  pkgs: []
  aux_pkgs: []

  aux_pkgs_state: ""

  scripts_dir: {{ scripts_dir }}

  # KDE configuration
  kde:
    mask_default_svc: plasma-kwin_x11.service
    user_svc_path: .config/systemd/user/plasma-i3.service
    user_svc: plasma-i3.service


  # Config files
  config_files:
    # i3
    - source: salt://i3/conf/i3.conf
      destination: .config/i3/config

    # Polybar
    - source: salt://i3/conf/polybar.ini
      destination: .config/polybar/config.ini

  # Programs to run
  bins:
    # I3 window manager
    i3: i3

    # Terminal program
    terminal: kitty

    # Screenshot program
    screenshot: zsh -c 'scrot ~/pictures/screenshots/%Y-%m-%d-%H:%M:%S.png'

    # List programs to then run
    app_launcher: rofi -show run

    # Background
    background: feh

    # Script to make caps lock a control key
    setup_keyboard: {{ scripts_dir }}/setup-keyboard.sh

    # Top status bar
    top_bar: {{ scripts_dir }}/polybar.sh

    # Bottom bar
    bottom_bar: lattce-dock

    # Logout command
    logout: exec --no-startup-id loginctl kill-session $XDG_SESSION_ID # exit
