# Installs Infracost, a Terraform cost estimator
infracost_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.infracost.multipkgs }}
