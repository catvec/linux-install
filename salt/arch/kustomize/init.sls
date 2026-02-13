# Installs Kubernetes Kustomize
kustomize_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.kustomize.multipkgs }}
