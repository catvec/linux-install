# Installs a display manager
display_manager_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.display_manager.multipkgs }}

# {{ pillar.display_manager.conf_dir }}:
#   file.recurse:
#     - source: salt://display-manager/sddm.conf.d/
#     - template: jinja
#     - clean: True
#     - requires:
#       - pkg: display_manager_pkgs

{% for file in pillar['display_manager']['conf_files'] %}
{{ pillar.display_manager.conf_dir }}/{{ file }}:
  file.managed:
    - source: salt://display-manager/sddm.conf.d/{{ file }}
    - template: jinja
    - makedirs: True
    - require:
      - multipkg: display_manager_pkgs
{% endfor %}

{{ pillar.display_manager.faces_dir }}:
  file.recurse:
    - source: salt://display-manager/faces/
    - clean: True
    - dir_mode: 755
    - file_mode: 644
    - require:
      - multipkg: display_manager_pkgs

{% for theme in pillar['display_manager']['themes'] %}
{{ pillar.display_manager.themes_dir }}/{{ theme }}:
  file.recurse:
    - source: salt://display-manager/themes/{{ theme }}
    - require:
      - multipkg: display_manager_pkgs
{% endfor %}

# The state doesn't start the service, just enable it
# If the service was started in the state every time the state runs the service would also be restarted
# On first install just reboot after running to get the effect
display_manager_svc_enabled:
  service.enabled:
    - name: {{ pillar.display_manager.svc }}
    - require:
      - multipkg: display_manager_pkgs
