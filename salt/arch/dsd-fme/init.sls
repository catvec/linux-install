# Installs DSD-FME (DSD Florida Man Edition)
dsd_fme_installed:
  makepkg.installed:
    - upstream_source: dsd-fme
    - patches:
        - salt://dsd-fme/patches/PKGBUILD-version.diff
