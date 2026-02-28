# Install and configure TMux

tmux_pkgs:
  multipkg.installed:
    - pkgs:
      - {{ pillar.tmux.pkg }}

{% if pillar.tmux.enable_config|default(true) %}
{{ pillar.tmux.configuration_file }}:
  file.managed:
    - source: salt://tmux/tmux.conf
    - user: noah
    - group: noah
    - mode: 644
{% endif %}
