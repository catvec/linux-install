# Clones down the agent skills repository
{% for user_key in pillar['agent_skills']['users'] %}

{% set user = pillar['users']['users'][user_key] %}
{% set dir = user['home'] + "/" + pillar['agent_skills']['home_relative_dir'] %}

agent_skills_cloned_{{ user_key }}:
  git.cloned:
    - name: {{ pillar.agent_skills.git_repo }}
    - user: {{ user['name'] }}
    - target: {{ dir }}

agent_skills_dir_{{ user_key }}:
  file.directory:
    - name: {{ dir }}
    - user: {{ user['name'] }}
    - group: {{ user['name'] }}
    - require:
      - git: agent_skills_cloned_{{ user_key }}
{% endfor %}
