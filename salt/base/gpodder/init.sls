# Installs gPodder, a podcast management app for iPods (https://gpodder.github.io/)
gpodder_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.gpodder.multipkgs }}
