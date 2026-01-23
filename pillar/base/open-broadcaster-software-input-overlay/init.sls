open_broadcaster_software_input_overlay:
  multipkgs: []

  overlay_presets:
    dir: /opt/obs-input-overlay

    # Distribution zip file is broken for now use fixed version
    # See: https://github.com/univrsal/input-overlay/issues/497
    url: salt://open-broadcaster-software-input-overlay/input-overlay-5.0.6-presets.fixed.zip
    sha256: 053b2d930268692e94c8b5ba3a64cc69f7bb08e283534f1669276e7af64ed8b3
