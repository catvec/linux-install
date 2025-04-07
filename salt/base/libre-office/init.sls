# Installs Libre Office

libre_office_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.libre_office.multipkgs }}
