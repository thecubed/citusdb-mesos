{
  "id": "/internal/citusdb/node1",
  "cmd": null,
  "cpus": 1,
  "mem": 4096,
  "disk": 0,
  "instances": 1,
  "constraints": [
    [
      "hostname",
      "LIKE",
      "node1.node.consul"
    ]
  ],
  "container": {
    "type": "DOCKER",
    "volumes": [
      {
        "containerPath": "/var/lib/postgresql/data",
        "hostPath": "/var/lib/docker/volumes/citus-slave",
        "mode": "RW"
      }
    ],
    "docker": {
      "image": "<your registry here>/citusdb-cloud",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 5432,
          "hostPort": 0,
          "servicePort": 0,
          "protocol": "tcp",
          "labels": {}
        }
      ],
      "privileged": false,
      "parameters": [],
      "forcePullImage": false
    }
  },
  "env": {
    "SERVICE_NAME": "citusdb-slave"
  },
  "healthChecks": [
    {
      "protocol": "TCP",
      "portIndex": 0,
      "gracePeriodSeconds": 300,
      "intervalSeconds": 60,
      "timeoutSeconds": 40,
      "maxConsecutiveFailures": 3,
      "ignoreHttp1xx": false
    }
  ],
  "portDefinitions": [
    {
      "port": 0,
      "protocol": "tcp",
      "labels": {}
    }
  ]
}
