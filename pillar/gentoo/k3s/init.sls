k3s:
  multipkgs:
    - pkg: sys-cluster/k3s

  svc:
    source: k3s.override.service
    install: /etc/systemd/system/k3s.service.d/override.conf
