# Installs Kdenlive, a linear video editor (https://apps.kde.org/kdenlive/)
kdenlive_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.kdenlive.multipkgs }}
