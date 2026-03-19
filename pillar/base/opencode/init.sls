opencode:
  # Packages to install
  multipkgs: []

  # Settings file relative to user home
  user_settings_file: .config/opencode/opencode.json
  user_plugins_dir: .config/opencode/plugins/

  # LLM API server
  base_url: http://lite-llm.ai.bagel.internal
  api_key: null

  # Model context protocols
  mcp:
    brave_search:
      enabled: true

  # Gotify hook plugin
  gotify_hook:
    enabled: false
    server_url: http://gotify.bagel.internal
    app_token: null
