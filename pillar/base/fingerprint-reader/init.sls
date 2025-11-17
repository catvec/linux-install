fingerprint_reader:
  # Package with fingerprint reader support
  pkgs: []

  # PAM configuration file
  pam_configuration_files:
    - system-local-login
    - sddm

  # Fingerprint service
  svc: fprintd
