#!/bin/sh
# ----------------------------------------------------------------------------
# entrypoint for squid container
# with changes from sameersbn/docker-squid to configure the cache
# ----------------------------------------------------------------------------
set -e

SQUID_VERSION=$(/usr/sbin/squid -v | grep Version | awk '{ print $4 }')

create_log_dir() {
  mkdir -p /var/log/squid
  chmod -R 755 /var/log/squid
  chown -R squid:squid /var/log/squid
}

create_cache_dir() {
  mkdir -p /var/cache/squid
  chown -R squid:squid /var/cache/squid
}

create_log_dir
create_cache_dir

# default behaviour is to launch squid
if [ "$1" == "squid" ]; then
  if [[ ! -d /var/cache/squid/00 ]]; then
    echo "Initializing cache..."
    /usr/sbin/squid -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid [${SQUID_VERSION}]"
  exec /sbin/su-exec root /usr/sbin/squid -N
else
  exec "$@"
fi
