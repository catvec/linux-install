# Installs scripts repository

# Download
{% for user_key in pillar['scripts_repo']['users'] %}
{% set user = pillar['users']['users'][user_key] %}

{{ pillar.scripts_repo.repository }}:
  git.cloned:
    - target: {{ user['home'] }}/{{ pillar.scripts_repo.home_relative_dir }}
    - user: {{ user['name'] }}

{{ pillar.scripts_repo.private_repository }}:
  git.cloned:
    - target: {{ user['home'] }}/{{ pillar.scripts_repo.home_relative_private_dir }}
    - user: {{ user['name'] }}
{% endfor %}
