# Installs OpenZFS
zfs_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.zfs.multipkgs }}

{% for svc in pillar['zfs']['services'] %}
{{ svc }}:
  service.running:
    - enable: true
    - require:
      - multipkg: zfs_pkgs
{% endfor %}
