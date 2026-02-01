# Installs Tailscale

tailscale_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.tailscale.multipkgs }}

tailscale_svc:
  service.running:
    - name: {{ pillar.tailscale.svc }}
    - enable: True
    - require:
        - multipkg: tailscale_pkgs

allowed_users_record_dir:
  file.directory:
    - name: {{ pillar.tailscale.allowed_users_record_dir }}

{% for user_key in pillar['tailscale']['allowed_users'] %}
{% set username = pillar['users']['users'][user_key]['name'] %}
{% set record_file = pillar['tailscale']['allowed_users_record_dir'] + "/" + username %}
tailscale_allow_{{ user_key }}:
  cmd.run:
    - name: tailscale set --operator={{ username }} && touch "{{ record_file }}"
    - unless: file -f "{{ record_file }}"
    - require:
      - multipkg: tailscale_pkgs
      - file: allowed_users_record_dir
{% endfor %}
