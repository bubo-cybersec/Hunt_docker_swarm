FROM  memcached:latest
USER root

RUN apt-get update && apt-get install -y \
        telnet \
        telnetd \
        libmemcached-tools \
        netcat
USER memcache

EXPOSE 11211
