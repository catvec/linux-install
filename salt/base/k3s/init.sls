# Installs and configures K3S to run services locally

# Install
k3s_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.k3s.multipkgs }}

# Custom service file which stops containers
{% if pillar['k3s']['svc']['kill_all_override_enabled'] %}
{{ pillar.k3s.svc.kill_all_override_install }}:
  file.managed:
    - source: salt://k3s/k3s.override.service
    - makedirs: True
    - require:
      - multipkg: k3s_pkgs
{% endif %}

# Manifest files
{{ pillar.k3s.helm_override_dir }}:
  file.recurse:
    - source: salt://k3s/helm-manifests

# Start service
{{ pillar.k3s.config_file }}:
  file.managed:
    - source: salt://k3s/config.yaml
    - template: jinja
    - makedirs: True
    - require:
      - multipkg: k3s_pkgs

{% if pillar['k3s']['svc']['enable_start'] %}
{{ pillar.k3s.svc.name }}:
  service.running:
    - enable: true
    - require:
      - multipkg: k3s_pkgs
      - file: {{ pillar.k3s.svc.kill_all_override_install }}
      - file: {{ pillar.k3s.config_file }}
{% endif %}
