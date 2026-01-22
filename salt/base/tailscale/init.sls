# Installs Tailscale

tailscale_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.tailscale.multipkgs }}
