# Installs Avahi a local network discovery service
avahi_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.avahi.multipkgs }}

avahi_enabled:
  service.enabled:
    - name: {{ pillar.avahi.svc }}

avahi_running:
  service.running:
    - name: {{ pillar.avahi.svc }}
    - require:
        - service: avahi_enabled
