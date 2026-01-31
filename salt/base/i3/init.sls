# Install and configure i3

# Install
i3_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.i3.multipkgs }}

# Scripts
{{ pillar.i3.scripts_dir }}:
  file.recurse:
    - source: salt://i3/scripts
    - clean: True
    - makedirs: True
    - dir_mode: 655
    - file_mode: 755



{% for user in pillar['users']['users'].values() %}
# KDE
{{ user['name'] }}_i3_kde_svc:
  file.managed:
    - name: {{ user['home'] }}/{{ pillar.i3.kde.user_svc_path }}
    - source: salt://i3/kde/plasma-i3.service
    - makedirs: True
    - template: jinja

{{ user['name'] }}_enable_i3_kde_svc:
  user_service.enabled:
    - name: {{ pillar.i3.kde.user_svc }}
    - user: {{ user['name'] }}
    - require:
        - file: {{ user['name'] }}_i3_kde_svc

{{ user['name'] }}_mask_default_kde_svc:
  user_service.masked:
    - name: {{ pillar.i3.kde.mask_default_svc }}
    - user: {{ user['name'] }}

# Configuration files
{% for config_file in pillar['i3']['config_files'] %}
{{ user['home'] }}/{{ config_file['destination'] }}:
  file.managed:
    - source: {{ config_file['source'] }}
    - template: jinja
    - user: {{ user['name'] }}
    - group: {{ user['name'] }}
    - makedirs: True
    - require:
      - multipkg: i3_pkgs
{% endfor %}
{% endfor %}
