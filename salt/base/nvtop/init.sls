# Installs NVTOP, a process & usage monitor for GPUs (https://github.com/Syllo/nvtop)
nvtop_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.nvtop.multipkgs }}
