# Setup network printing.
# Navigate to http://localhost:631 for the local web interface.
# Run system-config-printer for a GUI setup tool.

printer_pkgs:
  pkg.installed:
    - pkgs: {{ pillar.printers.pkgs }}

svc-enabled:
  service.enabled:
    - name: {{ pillar.printers.svc }}
    - require:
      - pkg: printer_pkgs

svc-running:
  service.running:
    - name: {{ pillar.printers.svc }}
    - require:
      - service: svc-enabled
