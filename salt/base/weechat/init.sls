# Install and configure Weechat.

# Configuration directory
{{ pillar.weechat.configuration_repo }}:
  git.cloned:
    - target: {{ pillar.weechat.configuration_directory }}
    - user: {{ pillar.ssh.default_ssh_user }}

# Install
{% for pkg in pillar['weechat']['pkgs'] %}
{{ pkg }}:
  pkg.latest:
    - require:
      - git: {{ pillar.weechat.configuration_repo }}
{% endfor %}
