# Install and configure SSH

# Install
ssh_pkgs:
  pkg.installed:
    - pkgs: {{ pillar.ssh.pkgs }}

# Configure
{{ pillar.ssh.config_file }}:
  file.managed:
    - source: salt://ssh/noah.config
    - user: noah
    - group: noah
    - mode: 600

# SSH server
{% if pillar['ssh']['server']['enabled'] %}
{{ pillar.ssh.server.config_path }}:
  file.managed:
    - source: salt://ssh/sshd_config
    - template: jinja

{% for user_key, authorized_keys in pillar['ssh']['server']['authorized_keys'].items() %}
{{ user_key }}_authorized_keys:
  file.managed:
    - name: {{ pillar['users']['users'][user_key]['home'] }}/{{ pillar.ssh.server.authorized_keys_home_relative }}
    - user: {{ pillar['users']['users'][user_key]['name'] }}
    - group: {{ pillar['users']['users'][user_key]['name'] }}
    - mode: 600
    - contents: |
        {%- for pubkey in authorized_keys %}
        {{ pubkey }}
        {%- endfor %}
{% endfor %}

{{ pillar.ssh.server.svc }}:
  service.running:
    - enable: True
{% endif %}
