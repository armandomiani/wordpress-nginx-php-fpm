FROM nginx:alpine

# Create /var/www and set permissions in crucial directories
# Set the pid in a location where nginx user has access:
#   sed will replace pid: (.*) topid /var/www/nginx.pid
RUN mkdir -p /var/www \
    && chown -R nginx:nginx /var/www \
    && chown -R nginx:nginx /var/cache/nginx /var/run /var/log/nginx \
    && sed -i -E \
        's/^pid(.*)$/pid\t\/var\/www\/nginx.pid;/g;' \
        /etc/nginx/nginx.conf

# Copy the custom NGINX configuration
COPY wordpress.conf /etc/nginx/conf.d/default.conf

# Copy the entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Switch to the non-root user
USER nginx

# Expose port 80 (HTTP)
EXPOSE 80
