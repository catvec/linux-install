# Installs Cables (A programatic visual art tool)
cables_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.cables.multipkgs }}
