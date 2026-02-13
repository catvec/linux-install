# Installs Installs ROCM ML runtime
amd_rocm_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.amd_rocm.multipkgs }}
