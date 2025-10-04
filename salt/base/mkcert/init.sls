# Installs mkcert (Local SSL)
mkcert_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.mkcert.multipkgs }}
