k3s:
  multipkgs:
    - aurpkg: k3s-bin

  svc:
    source: k3s.override.service
    install: /etc/systemd/system/k3s.service.d/override.conf
