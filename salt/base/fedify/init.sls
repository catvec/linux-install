# Installs the Fedify dev tool CLI (fedify.dev)
fedify_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.fedify.multipkgs }}
