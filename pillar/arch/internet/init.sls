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
    systemd_resolved: systemd-resolved.service
    systemd_resolved_sockets:
      - systemd-resolved-monitor.socket
      - systemd-resolved-varlink.socket

  wifi_interface: wlp166s0

  dns:
    use_external: false
    servers:
      - 1.1.1.1
      - 1.0.0.1
    conf_path: /etc/NetworkManager/conf.d/dns.conf
    systemd_resolved_conf_path: /etc/NetworkManager/conf.d/dns-systemd-resolved.conf

  connection_profiles_dir: /etc/NetworkManager/system-connections

  openvpn:
    vpn_certs_dir: /etc/openvpn/client
