virtualbox:
  pkgs: []
  network:
    host_only_adapter:
      name: vboxnet0
      ip: 10.10.10.1
      netmask: 255.255.255.0
      dhcp_enabled: true
      dhcp_range_start: 10.10.10.2
      dhcp_range_end: 10.10.10.254
