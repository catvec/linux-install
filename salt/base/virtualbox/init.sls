# Installs Virtual Box
virtualbox_pkgs:
  pkg.installed:
    - pkgs: {{ pillar.virtualbox.pkgs }}

# Configure VirtualBox network ranges
/etc/vbox/networks.conf:
  file.managed:
    - source: salt://virtualbox/networks.conf
    - makedirs: True
    - require:
      - pkg: virtualbox_pkgs
