# Installs Modprobed-db (Lists in used kernel modules)
modprobed_db_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.modprobed_db.multipkgs }}

{% for user in pillar['users']['users'].values() %}
svc_{{ user['name'] }}_enabled:
  user_service.enabled:
    - name: {{ pillar.modprobed_db.svc }}
    - user: {{ user['name'] }}
    - start: true
    - require:
        - multipkg: modprobed_db_pkgs
{% endfor %}
