# Installs the screen tool
screen_pkgs:
  pkg.installed:
    - pkgs: {{ pillar.screen.pkgs }}

{% for user_key, user in pillar['users']['users'].items() %}
{{ user_key }}_screenrc:
  file.managed:
    - name: {{ user['home'] }}/{{ pillar.screen.home_relative_screenrc_path }}
    - source: salt://screen/screenrc
    - user: {{ user['name'] }}
    - group: {{ user['name'] }}
    - require:
        - pkg: screen_pkgs
{% endfor %}
