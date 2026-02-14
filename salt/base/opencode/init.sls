# Installs OpenCode, an open source agent coding CLI (https://github.com/anomalyco/opencode)
opencode_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.opencode.multipkgs }}

{% for name, user in pillar['users']['users'].items() %}
{{ user['home'] }}/{{ pillar.opencode.user_settings_file }}:
  file.managed:
    - makedirs: True
    - source: salt://opencode/.opencode.json
    - template: jinja
    - replace: False
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - multipkg: opencode_pkgs
{% endfor %}
