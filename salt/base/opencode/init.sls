# Installs OpenCode, an open source agent coding CLI (https://github.com/anomalyco/opencode)
opencode_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.opencode.multipkgs }}

{% for name, user in pillar['users']['users'].items() %}
{{ user['home'] }}/{{ pillar.opencode.user_settings_file }}:
  file.managed:
    - makedirs: True
    - source: salt://opencode/opencode.json
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - multipkg: opencode_pkgs
{% endfor %}

{% if pillar.opencode.gotify_hook.enabled %}
/opt/opencode-plugins:
  file.directory:
    - mode: 755
    - makedirs: True

/opt/opencode-plugins/gotify-config.json:
  file.managed:
    - source: salt://opencode/plugins/gotify-config.json
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /opt/opencode-plugins

/opt/opencode-plugins/gotify-hook.mjs:
  file.managed:
    - source: salt://opencode/plugins/gotify-hook.mjs
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /opt/opencode-plugins
{% endif %}
