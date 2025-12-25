i3:
  pkgs:
    # i3 window manager
    - i3-wm

    # KDE plasma
    - plasma-meta
    - plasma-x11-session

    # Icon font
    - noto-fonts-emoji

    # Launcher
    - rofi

    # Background shower
    - feh

    # Status bar
    - polybar

  aux_pkgs:
    - ttf-material-icons-git
    - latte-dock

  aux_pkgs_state: aurpkg

  bins:
    # Temporarily use a built version of i3 bc it fixes (https://github.com/i3/i3/issues/6568)
    i3: /home/noah/documents/desktop/i3/build/i3
