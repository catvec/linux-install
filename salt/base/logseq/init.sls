# Installs Installs LogSeq desktop app
logseq_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.logseq.multipkgs }}
