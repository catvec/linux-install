# Installs the tree utility to list files
tree_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.tree.multipkgs }}
