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

install_google_search_mcp_{{ user['name'] }}:
  cmd.run:
    - name: |
        claude mcp add --transport stdio google-search --scope user \
            --env "GOOGLE_API_KEY={{ pillar.claude_code.mcp.google_search.api_key }}" \
            --env "GOOGLE_SEARCH_ENGINE_ID={{ pillar.claude_code.mcp.google_search.engine_id }}" \
            -- npx -y @adenot/mcp-google-search
    - runas: {{ user['name'] }}
    - unless: cat ~/.claude.json | grep google-search
    - require:
        - cmd: install_claude_code_{{ user['name'] }}
{% endfor %}
