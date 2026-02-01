tailscale:
  multipkgs: []

  svc: tailscaled

  # Users allowed to run tailscale not as root (Keys of users in the users pillar)
  allowed_users:
    - noah

  # Directory in which allowed users having been set are recorded
  allowed_users_record_dir: /var/tailscale-allowed-users
