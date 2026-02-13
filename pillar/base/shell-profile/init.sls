shell_profile:
  # Script to assemble all shell units into one file
  bake_script: /opt/bake-profiles/bake-profiles.sh

  # Directory in user's home directory to store raw shell units
  shell_profiles_dir: .profile.d

  # File which indicates which shell units to include
  units_file: .profile.units

  ### WHEN YOU ADD A NEW SHELL UNIT ADD IT TO all_shell_units TOO, OR ELSE IT WONT UNINSTALL ###
  # Shell units to include in the units_file
  shell_units: []

  # Compared against shell_units to get names of shell unit files which aren't installed
  all_shell_units:
    - meta_fns
    - usr_local_bin
    - keyboard
    - editor
    - terminal
    - pager
    - java
    - browser
    - screenshot_dir
    - gpg_tty
    - gpg2_alias
    - gpg_import
    - xdg_config_home
    - ssh_agent
    - history # Not need for ans
    - go
    - rust
    - deno
    - godot
    - chrome_executable
    - dotnet
    - prompt
    - ls_color
    - shell_reload_fn
    - user_bin
    - scripts_fns
    - org_mode
    - trash
    - edit_alias
    - salt_apply_alias
    - autocd
    - kubectl_alias
    - kube_namespace
    - git_alias
    - android_sdk
    - autostart
    - linux_install_edit
    - startx
    - start_wayland
    - doom_emacs
    - amd_rocm_path
