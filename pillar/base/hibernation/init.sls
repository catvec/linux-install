hibernation:
  # Systemd logind drop-in configuration directory
  logind_conf_dir: /etc/systemd/logind.conf.d

  # Systemd logind drop-in configuration file for suspend-then-hibernate
  logind_conf_file: /etc/systemd/logind.conf.d/hibernation.conf

  # Systemd sleep drop-in configuration directory
  sleep_conf_dir: /etc/systemd/sleep.conf.d

  # Systemd sleep drop-in configuration file for hibernate delay
  sleep_conf_file: /etc/systemd/sleep.conf.d/hibernation.conf

  # Hibernate delay in seconds - only used when hibernation_enabled is true
  hibernate_delay: 1200

  # Default: disable hibernation
  hibernation_enabled: false
