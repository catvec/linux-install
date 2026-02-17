# Installs the Particle CLI and operating system repo.

# CLI
{{ pillar.particle.cli.repo }}:
  git.cloned:
    - user: {{ pillar.ssh.default_ssh_user }}
    - target: {{ pillar.particle.cli.dir }}

{{ pillar.particle.cli.link.name }}:
  file.symlink:
    - target: {{ pillar.particle.cli.link.target }}

# OS LIB
{{ pillar.particle.lib.repo }}:
  git.latest:
    - user: noah
    - target: {{ pillar.particle.lib.target }}
    - rev: {{ pillar.particle.lib.branch }}
    - depth: 1
    - submodules: True

{% for pkg in pillar['particle']['lib']['dep_pkgs'] %}
{{ pkg }}:
  pkg.installed
{% endfor %}
