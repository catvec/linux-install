# Installs Gcloud CLI
gcloud_cli_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.gcloud_cli.multipkgs }}
