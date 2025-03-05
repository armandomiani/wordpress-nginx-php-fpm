# WordPress and PHP Versioning Requirements
# https://make.wordpress.org/core/handbook/references/php-compatibility-and-wordpress-versions/

FROM php:8.3-fpm-alpine

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
      mysql-client \
      bash \
      curl \
      libzip-dev \
      libpng-dev \
      libjpeg-turbo-dev \
      freetype-dev \
      unzip \
      # Install PHP extensions
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip opcache \
  # Clean up to reduce image size
  && rm -rf /var/cache/apk/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Download and extract WordPress
WORKDIR /tmp
RUN curl -o wordpress.zip -s "https://wordpress.org/latest.zip" \
  && unzip wordpress.zip -d /tmp/ \
  && mv /tmp/wordpress/* /var/www/html/ \
  && rm -rf /tmp/wordpress wordpress.zip

# Set the permissions for WordPress files
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp \
  && wp --info

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Copy custom scripts
COPY wordpress-entrypoint.sh /wordpress-entrypoint.sh
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wordpress-entrypoint.sh /wait-for-it.sh

# Switch to non-root user
USER www-data

# Set the entrypoint and default command
ENTRYPOINT ["/wordpress-entrypoint.sh"]
CMD ["php-fpm"]
