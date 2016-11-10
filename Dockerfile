# Use postgres 9.6 base image, and extend it
FROM postgres:9.6

MAINTAINER Tyler Montgomery <http://github.com/thecubed>

# Install CitusDB extensions
RUN apt-get -y update && \
	apt-get -y install curl && \
	curl -s https://packagecloud.io/install/repositories/citusdata/community/script.deb.sh | bash && \
	apt-get -y install postgresql-9.6-citus=6.0.0.citus-1 unzip

# Add our scripts to manage CitusDB
ADD *.sh /docker-entrypoint-initdb.d/

# Add our Consul template file
ADD pg_worker_list.tmpl /root/pg_worker_list.tmpl

# Add consul-template
ADD https://releases.hashicorp.com/consul-template/0.15.0/consul-template_0.15.0_linux_amd64.zip /tmp/consul-template.zip
RUN cd /tmp && unzip /tmp/consul-template.zip && mv /tmp/consul-template /usr/local/bin/consul-template
