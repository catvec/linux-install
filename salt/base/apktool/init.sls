# Installs Apktool (https://apktool.org/)

# Download the wrapper script
{{ pillar.apktool.install_dir }}/apktool:
  file.managed:
    - source: {{ pillar.apktool.wrapper_script_url }}
    - source_hash: {{ pillar.apktool.wrapper_script_hash }}
    - mode: 755

# Download the JAR file
{{ pillar.apktool.install_dir }}/apktool.jar:
  file.managed:
    - source: {{ pillar.apktool.jar_url }}
    - source_hash: {{ pillar.apktool.jar_hash }}
    - mode: 644
