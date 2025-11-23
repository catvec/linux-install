# Configures the sudoers file to allow users in the wheel group to use sudo 
# without entering their password.

{% if 'pkg' in pillar['sudoers'] and pillar['sudoers']['pkg'] is not none %}
{{ pillar.sudoers.pkg }}:
  pkg.installed
{% endif %}
sudoers_multipkgs:
  multipkg.installed:
    - pkgs: {{ pillar.sudoers.multipkgs }}

{% set sudo_config_file = 'sudo-group-require-password' if pillar['sudoers']['password_required'] else 'sudo-group-no-password' %}
{{ pillar.sudoers.sudoers_d_path }}/{{ sudo_config_file }}:
  file.managed:
    - source: salt://sudoers/sudoers.d/{{ sudo_config_file }}
    - makedirs: True
    - template: jinja
    - check_cmd: visudo -c -f
    - require:
      - multipkg: sudoers_multipkgs
