internet:
  pkgs:
    - networkmanager
    - networkmanager-openvpn

    # L2TP
    - networkmanager-l2tp
    - networkmanager-strongswan
    - strongswan

  svcs:
    network_manager: NetworkManager.service
    systemd_resolved: systemd-resolved

  wifi_interface: wlp166s0
  connection_profiles_dir: /etc/NetworkManager/system-connections

  dns:
    use_external: true
    servers:
      - 1.1.1.1
      - 1.0.0.1
