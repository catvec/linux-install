k3s:
  # Packages required to install k3s
  multipkgs: []

  # Service file
  svc:
    name: k3s

    enable_start: false
    
    # This custom service override stops all containers when the service exits (useful for running k3s as a local test cluster, not useful for running k3s in production)
    kill_all_override_enabled: false
    kill_all_override_install: /etc/systemd/system/k3s.service.d/override.conf
  
  # TLS SANs for the API server certificate
  # Add Tailscale IPs or hostnames here for proper certificate validation
  # To change, stop the service, run k3s certificate rotate api-server
  tls_san: []

  # Configuration file
  config_file: /etc/rancher/k3s/config.yaml

  # Helm override dir
  helm_override_dir: /var/lib/rancher/k3s/server/manifests/
