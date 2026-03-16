gotify_client_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.gotify_client.multipkgs }}

{{ pillar.gotify_client.gotify_tray_desktop_file }}:
  file.managed:
    - source: salt://gotify-client/gotify-tray.desktop