# Installs NX (NodeJs mono repo tool, https://nx.dev)
nx_pkgs:
  npm.installed:
    - pkgs: {{ pillar.nx.pkgs }}
