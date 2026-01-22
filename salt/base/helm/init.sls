# Installs a Kubernetes distribution tool (https://helm.sh)
helm_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.helm.multipkgs }}
