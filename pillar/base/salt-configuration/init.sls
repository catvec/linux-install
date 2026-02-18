{% set content_root = '/srv' %}

salt_configuration:
  # Salt minion configuration file locations
  config_files:
    - /etc/salt/minion
    - /etc/linux-install/salt/base/salt-configuration/minion.templated

  # Custom modules directory
  custom_modules_dir: {{ content_root }}/salt/base/_modules

  # State directories
  state_dirs:
    base:
      public: {{ content_root }}/salt/base
      secret: {{ content_root }}/salt/base-secret
    void:
      public: {{ content_root }}/salt/void
    gentoo:
      public: {{ content_root }}/salt/gentoo
    arch:
      public: {{ content_root }}/salt/arch
    work:
      public: {{ content_root }}/salt/work
    wsl:
      public: {{ content_root }}/salt/wsl

  # Pillar directories
  pillar_dirs:
    base:
      public: {{ content_root }}/pillar/base
    void:
      public: {{ content_root }}/pillar/void
    gentoo:
      public: {{ content_root }}/pillar/gentoo
    arch:
      public: {{ content_root }}/pillar/arch
    work:
      public: {{ content_root }}/pillar/work
    wsl:
      public: {{ content_root }}/pillar/wsl

  # Pillar stack configuration files
  pillar_stack:
    base:
      public: {{ content_root }}/pillar/base/pillar-stack.cfg
      secret: {{ content_root }}/pillar/base-secret/pillar-stack.cfg
    void:
      public: {{ content_root }}/pillar/void/pillar-stack.cfg
    gentoo:
      public: {{ content_root }}/pillar/gentoo/pillar-stack.cfg
      secret: {{ content_root }}/pillar/gentoo-secret/pillar-stack.cfg
    arch:
      public: {{ content_root }}/pillar/arch/pillar-stack.cfg
      secret: {{ content_root }}/pillar/arch-secret/pillar-stack.cfg
    work:
      public: {{ content_root }}/pillar/work/pillar-stack.cfg
    wsl:
      public: {{ content_root }}/pillar/wsl/pillar-stack.cfg
