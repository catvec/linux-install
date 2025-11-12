# Installs Ollama (run LLMs locally)
ollama_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.ollama.multipkgs }}
