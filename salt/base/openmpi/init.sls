# Installs Installs Open MPI (message passing interface)
openmpi_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.openmpi.multipkgs }}
