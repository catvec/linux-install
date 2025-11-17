# Installs Ollama (run LLMs locally)
ollama_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.ollama.multipkgs }}

{% for user in pillar['users']['users'].values() %}
{{ user['name'] }}_run_script:
  file.managed:
    - name: {{ user['home'] }}/{{ pillar.ollama.run_script_user_path }}
    - source: salt://ollama/ollama-env
    - mode: 755
{% endfor %}
