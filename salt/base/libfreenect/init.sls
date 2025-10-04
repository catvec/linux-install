# Installs libfreenect (XBox Kinnect library)
libfreenect_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.libfreenect.multipkgs }}
