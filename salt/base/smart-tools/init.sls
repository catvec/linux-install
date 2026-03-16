# Installs S.M.A.R.T are introspection tools built into many storage devices
smart_tools_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.smart_tools.multipkgs }}
