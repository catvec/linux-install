salt_virtual_environment:
  shortcut_script_install_dir: /usr/local/bin/
  venv_bin_dir: /etc/linux-install/.venv/bin

  # Files in venv bin dir that shortcut files should be created
  venv_shortcut_targets:
    - salt
    - salt-api
    - salt-call
    - salt-cloud
    - salt-cp
    - salt-key
    - salt-master
    - salt-minion
    - salt-pip
    - salt-proxy
    - salt-run
    - salt-ssh
    - salt-syncdir
