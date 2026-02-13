git:
  multipkgs:
    - pkg:
      - git
      - patchutils

      # so git send-email can authenticate with SMTP
      - perl-authen-sasl
      - perl-mime-tools
    - aurpkg: git-credential-manager
