# Installs Bun, a JavaScript runtime (https://bun.sh/)
bun_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.bun.multipkgs }}
