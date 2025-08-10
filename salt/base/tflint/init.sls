# Installs Tflint, a Terraform linter
tflint_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.tflint.multipkgs }}
