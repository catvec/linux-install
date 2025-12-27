# Installs android SDK
# Download sdk tools and then copy them into the right directory
{{ pillar.android_sdk.cli_tools_extract_parent_dir }}:
  archive.extracted:
    - source: {{ pillar.android_sdk.cli_tools_url }}
    - source_hash: {{ pillar.android_sdk.cli_tools_hash }}

{{ pillar.android_sdk.cli_tools_dir }}:
  file.copy:
    - source: {{ pillar.android_sdk.cli_tools_extract_target_dir }}
    - makedirs: True
    - require:
      - archive: {{ pillar.android_sdk.cli_tools_extract_parent_dir }}

# Accept licenses
accept_licenses:
  cmd.run:
    - name: yes | {{ pillar.android_sdk.cli_tools_dir }}/bin/sdkmanager --licenses
    - env:
      - JAVA_HOME: {{ pillar.java.java_home }}
    - require:
      - file: {{ pillar.android_sdk.cli_tools_dir }}

# Create udev group
{{ pillar.android_sdk.udev_group }}:
  group.present:
    - members:
      - noah

# udev rules file
{{ pillar.android_sdk.udev_rules_file }}:
  file.managed:
    - source: salt://android-sdk/udev.rules
    - template: jinja
    
# Install SDK packages
{% for pkg in pillar['android_sdk']['sdk_pkgs'] %}
{{ pillar.android_sdk.cli_tools_dir }}/bin/sdkmanager '{{ pkg }}':
  cmd.run:
    - env:
      - JAVA_HOME: {{ pillar.java.java_home }}
    - require:
      - cmd: accept_licenses
{% endfor %}

# Set permissions so all users can access the SDK
set_sdk_permissions:
  cmd.run:
    - name: chmod -R 755 {{ pillar.android_sdk.sdk_root }}
    - require:
      - cmd: accept_licenses

