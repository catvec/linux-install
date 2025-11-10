# Installs Deno (JS runtime)
deno_multipkgs:
  multipkg.installed:
    - pkgs: {{ pillar.deno.multipkgs }}
