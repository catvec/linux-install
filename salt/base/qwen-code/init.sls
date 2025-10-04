# Installs Qwen Code an agent coding tool
qwen_code_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.qwen_code.multipkgs }}
