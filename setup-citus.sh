#!/bin/bash -x

##
## Set up a CitusDB node.
## This script adds the citus extension to the postgresql.conf file and adds the extension to the default (postgres) database
##

if ! grep -q citus ${PGDATA}/postgresql.conf ; then
	echo "Configuring CitusDB as a shared postgres extension..."
	echo "shared_preload_libraries = 'citus'" >> ${PGDATA}/postgresql.conf
	echo "Restarting postgres and creating the extension in the default database..."
	gosu postgres pg_ctl -D "$PGDATA" -m fast -w restart
	psql -U ${POSTGRES_USER} -c "CREATE EXTENSION citus;"
else
	echo "CitusDB already configured. Continuing with boot..."
fi
