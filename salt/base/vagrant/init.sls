# Installs Vagrant
vagrant_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.vagrant.multipkgs }}

# Install Vagrant plugins
{% for plugin in pillar.vagrant.plugins %}
vagrant_plugin_{{ plugin.replace('-', '_') }}:
  cmd.run:
    - name: vagrant plugin install {{ plugin }}
    - unless: vagrant plugin list | grep -q {{ plugin }}
    - require:
      - multipkg: vagrant_pkgs
{% endfor %}
