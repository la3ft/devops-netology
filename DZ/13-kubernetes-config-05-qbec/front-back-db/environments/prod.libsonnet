
local prod = import './stage.libsonnet';

prod {
  components +: {
    backend +: {
      replicas: 3,
    },
    frontend +: {
      replicas: 3,
    },
    db +: {
      replicas: 3,
    },
    endpoint: {
      address: "158.160.58.47"
    }
  }
}