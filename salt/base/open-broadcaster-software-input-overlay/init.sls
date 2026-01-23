# Installs OBS Input Overlay (https://github.com/univrsal/input-overlay/)
open_broadcaster_software_input_overlay_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.open_broadcaster_software_input_overlay.multipkgs }}

# Download presets
{{ pillar.open_broadcaster_software_input_overlay.overlay_presets.dir }}:
  archive.extracted:
    - source: {{ pillar.open_broadcaster_software_input_overlay.overlay_presets.url }}
    - source_hash: {{ pillar.open_broadcaster_software_input_overlay.overlay_presets.sha256 }}
    - enforce_toplevel: False
