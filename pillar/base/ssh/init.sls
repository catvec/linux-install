ssh:
  # Package
  pkgs: []

  # Configuration file
  config_file: /home/noah/.ssh/config

  # Server configuration
  server:
    enabled: false
    config_path: /etc/ssh/sshd_config
    svc: sshd
    authorized_keys_home_relative: .ssh/authorized_keys
