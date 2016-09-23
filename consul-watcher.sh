#!/bin/bash -x

##
## This script is used to handle starting the CitusDB master.
## Env vars used:
## - CITUS_MASTER = true
##   Setting this to anything enables this image to act as a CitusDB master
## - CITUS_SLAVE_NAME = (string)
##   The Consul name of the CitusDB slave nodes.
## - CONSUL_ADDR = 172.17.42.1:8500 / (host:port)
##   The host:port for the docker container to contact your Consul cluster on.
##   Default is to use the docker0 IP.
##

# This script should only run if we're a master
if [ -z "${CITUS_MASTER}" ]; then
	echo "This server is not a citusDB master. Set CITUS_MASTER to enable it."
	return
fi

# Check if we have enough information to contact the slaves
if [ -z "${CITUS_SLAVE_NAME}" ]; then
	echo "Please set CITUS_SLAVE_NAME to the Consul service name for your citusDB slaves. Consul-template cannot find slaves otherwise. Not running as a master."
	return
fi

# 
if [ -z "${CONSUL_ADDR}" ]; then
	CONSUL_ADDR="172.17.42.1:8500"
fi

# Edit the consul-template template to include our env var
sed -i -e "s/__CITUS_SLAVE_NAME__/${CITUS_SLAVE_NAME}/" /root/pg_worker_list.tmpl

# Start consul-template as a daemon (automatically)
consul-template -template="/root/pg_worker_list.tmpl:${PGDATA}/pg_worker_list.conf:psql -U ${POSTGRES_USER} -h localhost -c 'SELECT pg_reload_conf();' || true" -consul ${CONSUL_ADDR} &
