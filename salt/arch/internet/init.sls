# Install and configure NetworkManager

# Install packages
internet_pkgs:
  pkg.installed:
    - pkgs: {{ pillar.internet.pkgs }}

{{ pillar.internet.openvpn.vpn_certs_dir }}:
  file.recurse:
    - source: salt://internet-secret/openvpn-certs/
    - makedirs: True
    - dir_mode: 600
    - file_mode: 600

# Enable services
{{ pillar.internet.svcs.network_manager }}:
  service.running:
    - enable: True
    - require:
      - pkg: internet_pkgs

{{ pillar.internet.svcs.systemd_resolved }}:
  service.running:
    - enable: True

# Configure connection profiles
# ... Internet 
{% for name, config in pillar['internet']['wpa_supplicant']['networks'].items() %}
{{ pillar.internet.connection_profiles_dir }}/{{ name }}.nmconnection:
  file.managed:
    - source: salt://internet/internet.nmconnection
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - defaults:
        name: {{ name }}
        config: {{ config }}
    - require:
      - pkg: internet_pkgs
{% endfor %}

# ... VPN
{% for name, config in pillar['internet']['openvpn']['profiles'].items() %}
{{ pillar.internet.connection_profiles_dir }}/{{ name }}.nmconnection:
  file.managed:
    - source: salt://internet/openvpn.nmconnection
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - defaults:
        name: {{ name }}
        config: {{ config }}
    - require:
      - pkg: internet_pkgs
{% endfor %}
