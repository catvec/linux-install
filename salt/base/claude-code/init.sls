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

install_brave_search_mcp_{{ user['name'] }}:
  cmd.run:
    - name: |
        claude mcp add --transport stdio brave-search --scope user \
            --env BRAVE_API_KEY={{ pillar.claude_code.mcp.brave_search.api_key }} \
            -- npx -y @modelcontextprotocol/server-brave-search
    - runas: {{ user['name'] }}
    - unless: cat ~/.claude.json | grep google-search
    - require:
        - cmd: install_claude_code_{{ user['name'] }}
{% endfor %}
