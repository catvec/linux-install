display_manager:
  multipkgs: []
  svc: sddm

  conf_dir: /etc/sddm.conf.d
  conf_files:
    #- 10-wayland.conf
    - 10-x11.conf
    - 20-theme.conf

  faces_dir: /usr/share/sddm/faces/
  
  themes_dir: /usr/share/sddm/themes
  themes:
    - Sweet
