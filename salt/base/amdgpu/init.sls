# Installs AMD GPU support
amdgpu_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.amdgpu.multipkgs }}
