# Configures the Salt minion to find Salt states in custom directories.
{% for file in pillar.salt_configuration.config_files %}
{{ file }}:
  file.managed:
    - source: salt://salt-configuration/minion
    - mode: 664
    - template: jinja
{% endfor %}
