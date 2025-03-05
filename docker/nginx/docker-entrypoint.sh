#!/bin/sh
set -e

# Fix permissions for /var/log/nginx
mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx

# Start container
exec "$@"
