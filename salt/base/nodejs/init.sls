# Install Node JS

nodejs_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.nodejs.multipkgs }}
