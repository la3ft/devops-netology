
{
  components: {

    "backend": {
      "replicas": 1,
      "name": "backend",
      "image": "la3ft/netology-back:latest",
      "ports": {
        "containerPort": 9000
      },
      "service": {
        "port": 9000
      }
    },

    "frontend": {
      "replicas": 1,
      "name": "frontend",
      "image": "la3ft/netology-front:latest",
      "ports": {
         "containerPort": 80
      },
      "service": {
         "port": 80
      },
      "endpoint": false
    },

    "db": {
      "replicas": 1,
      "name": "db",
      "image": "postgres:14-alpine",
      "ports": {
         "containerPort": 5432
      },
      "service": {
         "port": 5432
      }
    },
  }
}