{% set version = '12.5.7' %}
{% set dir = '/opt/yay' %}

{% import_yaml 'salt-configuration/init.sls' as salt_config %}

yay:
  aux_pkgs:
    # Required to build packages
    - base-devel
    
    # Required as a tool during build time for packages
    - fakeroot
  
  download:
    url: https://github.com/Jguer/yay/releases/download/v{{ version }}/yay_{{ version }}_x86_64.tar.gz
    sha: 28b3c5d3fd39d9b123c58f3f2689783da11e4a48bf6ed660a6dc7fe6aabdbeb3
    dir: {{ dir }}

  link:
    target: /usr/local/bin/yay
    source: {{ dir }}/yay_{{ version }}_x86_64/yay
