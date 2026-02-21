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

# NetworkManager DNS configuration
{% if pillar.internet.dns.use_external %}
{{ pillar.internet.dns.conf_path }}:
  file.managed:
    - source: salt://internet/dns.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: internet_pkgs
{% else %}
{{ pillar.internet.dns.systemd_resolved_conf_path }}:
  file.managed:
    - source: salt://internet/dns-systemd-resolved.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: internet_pkgs
{% endif %}

# Enable services
{{ pillar.internet.svcs.network_manager }}:
  service.running:
    - enable: True
    - require:
      - pkg: internet_pkgs

{% if pillar.internet.dns is not defined or not pillar.internet.dns.use_external %}
# Using systemd-resolved - ensure service is running
{{ pillar.internet.svcs.systemd_resolved }}:
  service.running:
    - enable: True
{% for socket in pillar.internet.svcs.systemd_resolved_sockets %}
# Unmask sockets when using systemd-resolved
{{ socket }}:
  service.masked:
    - mask: False
{% endfor %}
{% else %}
# Using external DNS - stop and mask systemd-resolved
{{ pillar.internet.svcs.systemd_resolved }}:
  service.dead:
    - enable: False
    - mask: True
{% for socket in pillar.internet.svcs.systemd_resolved_sockets %}
{{ socket }}:
  service.dead:
    - enable: False
    - mask: True
{% endfor %}
{% endif %}

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
