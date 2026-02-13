# Install and select kernel
kernel_pkg:
  pkg.installed:
    - pkgs:
      - {{ pillar.kernel.kernel_pkg }}

{{ pillar.kernel.modprobe_dir }}:
  file.recurse:
    - source: salt://kernel/modprobe.d/
    - clean: True

{{ pillar.kernel.mkinitcpio.conf_path }}:
  file.managed:
    - source: salt://kernel/mkinitcpio.conf
    - template: jinja

{{ pillar.kernel.vconsole_conf_file }}:
  file.managed:
    - source: salt://kernel/vconsole.conf
