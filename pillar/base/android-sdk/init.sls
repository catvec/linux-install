{% set sdk_root = '/opt/android-sdk' %}
{% set cli_tools_extract_parent_dir = sdk_root + '/download' %}
{% set cli_tools_extract_target_dir = cli_tools_extract_parent_dir + '/cmdline-tools' %}
{% set cli_tools_dir = sdk_root + '/cmdline-tools/latest' %}
android_sdk:
  sdk_root: {{ sdk_root }}

  # SDK tools files
  cli_tools_extract_parent_dir: {{ cli_tools_extract_parent_dir }}
  cli_tools_extract_target_dir: {{ cli_tools_extract_target_dir }}
  cli_tools_dir: {{ cli_tools_dir }}

  # https://developer.android.com/studio
  # or
  # https://developer.android.com/studio#command-line-tools-only
  cli_tools_url: https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
  cli_tools_hash: 7ec965280a073311c339e571cd5de778b9975026cfcbe79f2b1cdcb1e15317ee

  # Users in group can access Android devices
  udev_group: androiddev

  # udev rules rule so devices can be discovered
  udev_rules_file: /etc/udev/rules.d/51-android.rules
  
  # SDK packages
  sdk_pkgs:
    # Versions Android platform 33, and build tools 30 required by flutter
    - build-tools;30.0.3
    - platform-tools
    - platforms;android-33
    - tools
    - emulator
