# Installs DSD-FME (DSD Florida Man Edition)
{{ pillar.dsd_fme.pkgbuild.path }}:
  makepkg.installed
# {{ pillar.dsd_fme.pkgbuild.path }}:
#   file.managed:
#     - source: salt://dsd-fme/PKGBUILD
#     - makedirs: True

# build_package:
#   cmd.run:
#     - name: 'makepkg -si --noconfirm'
#     - cwd: {{ pillar.dsd_fme.pkgbuild.dir }}
#     - require:
#         - file: {{ pillar.dsd_fme.pkgbuild.path }}
#     #- unless: 'test -f /tmp/{}.pkg.tar.zst'.format(pkg_name)  # Check if package already exists
