fingerprint_reader:
  # Package with fingerprint reader support
  pkgs: []

  # PAM configuration file
  pam_configuration_files:
    - system-local-login
    - sddm
    - su
    - sudo
    - polkit-1

  # Fingerprint service
  svc: fprintd
