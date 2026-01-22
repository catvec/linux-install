# Installs the Claude Code agent CLI

{{ pillar.claude_code.installer_file }}:
  file.managed:
    - source: {{ pillar.claude_code.installer_url }}
    - source_hash: {{ pillar.claude_code.installer_sha256sum }}
    - makedirs: True

{% for user in pillar['users']['users'].values() %}
install_claude_code_{{ user['name'] }}:
  cmd.run:
    - name: bash {{ pillar.claude_code.installer_file }}
    - runas: {{ user['name'] }}
    - creates: {{ user['home'] }}/{{ pillar.claude_code.user_install_file }}
    - require:
      - file: {{ pillar.claude_code.installer_file }}
{% endfor %}
