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
{% for user_key, user in pillar['users']['users'].items() %}
{% set plugin_dir = user['home'] + '/' + pillar['opencode']['user_plugins_dir'] %}

{{ plugin_dir }}:
  file.directory:
    - mode: 755
    - user: {{ user['name'] }}
    - group: {{ user['name'] }}
    - makedirs: True

{{ plugin_dir }}/gotify-config.json:
  file.managed:
    - source: salt://opencode/plugins/gotify-config.json
    - template: jinja
    - user: {{ user['name'] }}
    - group: {{ user['name'] }}
    - mode: 644
    - require:
      - file: {{ plugin_dir }}

{{ plugin_dir }}/gotify-hook.ts:
  file.managed:
    - source: salt://opencode/plugins/gotify-hook.ts
    - user: {{ user['name'] }}
    - group: {{ user['name'] }}
    - mode: 644
    - require:
      - file: {{ plugin_dir }}
{% endfor %}
{% endif %}
