# Salt virtual environment
{% for target_file in pillar['salt-virtual-environment']['venv_shortcut_targets'] %}
{{ pillar.salt_virtual_environment.shortcut_script_install_dir }}/{{ target_file }}:
  file.managed:
    - source: salt://salt-virtual-environment/salt-shortcut
    - mode: 755
    - template: jinja
    - context:
        target_file: {{ target_file }}
{% endfor %}
