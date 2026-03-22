# Installs Discord
discord_multipkgs:
  multipkg.installed:
    - pkgs: {{ pillar.discord.multipkgs }}

{% if pillar['discord']['vesktop']['override_desktop_icon'] %}
{{ pillar.discord.vesktop.icon_file }}:
  file.managed:
    - source: salt://discord/discord.png
    - mode: 644

{{ pillar.discord.vesktop.desktop_entry_file }}:
  file.managed:
    - source: salt://discord/vesktop.desktop
    - template: jinja
    - mode: 644
    - require:
        - multipkg: discord_multipkgs
{% endif %}
