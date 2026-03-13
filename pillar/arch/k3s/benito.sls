k3s:
  svc:
    enable_start: true

  # Label required for OpenEBS to run storage controller on node
  node_label: openebs.io/engine=mayastor
