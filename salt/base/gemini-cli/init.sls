# Installs Gemini LLM CLI (https://github.com/google-gemini/gemini-cli)
gemini_cli_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.gemini_cli.multipkgs }}
