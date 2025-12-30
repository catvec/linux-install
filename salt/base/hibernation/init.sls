# Configure suspend-then-hibernate mode
# When the lid is closed, the system will suspend immediately,
# then automatically hibernate after the configured delay

# Configure logind to use suspend-then-hibernate
{{ pillar.hibernation.logind_conf_dir }}:
  file.directory:
    - makedirs: True

{{ pillar.hibernation.logind_conf_file }}:
  file.managed:
    - source: salt://hibernation/logind.conf
    - makedirs: True
    - require:
      - file: {{ pillar.hibernation.logind_conf_dir }}

# Configure the hibernate delay
{{ pillar.hibernation.sleep_conf_dir }}:
  file.directory:
    - makedirs: True

{{ pillar.hibernation.sleep_conf_file }}:
  file.managed:
    - source: salt://hibernation/sleep.conf
    - makedirs: True
    - require:
      - file: {{ pillar.hibernation.sleep_conf_dir }}

# Restart systemd-logind to apply changes
restart-systemd-logind:
  cmd.run:
    - name: systemctl restart systemd-logind.service
    - onchanges:
      - file: {{ pillar.hibernation.logind_conf_file }}
      - file: {{ pillar.hibernation.sleep_conf_file }}
