# Installs Ollama-Code, a fork of qwen-code meant to work with local Ollama models (https://github.com/tcsenpai/ollama-code)
ollama_code_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.ollama_code.multipkgs }}
