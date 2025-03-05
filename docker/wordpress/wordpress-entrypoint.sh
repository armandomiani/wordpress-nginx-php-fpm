#!/bin/bash
set -euo pipefail

# If WORDPRESS_DB_PREFIX is not set, defaults it to: "wp"
export WORDPRESS_DB_PREFIX="${WORDPRESS_DB_PREFIX:-wp}"

# WordPress installation path
readonly WORDPRESS_PATH="/var/www/html"

# Required environment variables
readonly REQUIRED_VARIABLES=(
  WORDPRESS_DB_PASSWORD
  WORDPRESS_DB_HOST
  WORDPRESS_DB_USER
  WORDPRESS_DB_NAME
)

# Logging function with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if required variables are set
validate_required_vars() {
  for var in "${REQUIRED_VARIABLES[@]}"; do
    if [[ -z "${!var:-}" ]]; then
      log "Error: Required variable '$var' is not set." >&2
      exit 1
    else
      log "Variable '$var' is set."
    fi
  done
  log "All required variables are set."
}

# Wait for MySQL to be ready
wait_for_mysql() {
  log "Waiting for MySQL to be ready..."
  /wait-for-it.sh "${WORDPRESS_DB_HOST}:3306" --timeout=60 --strict
  log "MySQL is ready!"
}

# Create the configuration file
create_config() {
  local config_path="${WORDPRESS_PATH}/wp-config.php"

  if [[ ! -f "${config_path}" ]]; then
    log "Creating wp-config.php..."
    wp config create \
      --dbname="${WORDPRESS_DB_NAME}" \
      --dbuser="${WORDPRESS_DB_USER}" \
      --dbpass="${WORDPRESS_DB_PASSWORD}" \
      --dbhost="${WORDPRESS_DB_HOST}" \
      --dbprefix="${WORDPRESS_DB_PREFIX}" \
      --path="${WORDPRESS_PATH}"
    log "wp-config.php created at: ${config_path}"
  else
    log "wp-config already present: ${config_path}"
  fi
}

# If WordPress is not installed, installs it. Otherwise, skips installation
maybe_install_wordpress() {
  if ! wp core is-installed --path="${WORDPRESS_PATH}" 2>/dev/null; then
    log "Installing WordPress..."
    wp core install \
      --path="${WORDPRESS_PATH}" \
      --url="localhost" \
      --title="Example" \
      --admin_user="supervisor" \
      --admin_password="strongpassword" \
      --admin_email="info@example.com"
    log "WordPress installed successfully."
  else
    log "WordPress already installed at: ${WORDPRESS_PATH}"
  fi
}

# Handle script interruptions gracefully
trap 'log "Script interrupted"; exit 1' SIGTERM SIGINT

# Main script execution
main() {
  log "Running WordPress setup..."

  # Check if all required variables are set
  validate_required_vars

  # Wait for MySQL
  wait_for_mysql

  # Create the wp-config.php
  create_config

  # Install WordPress if it's not installed
  maybe_install_wordpress

  log "WordPress setup finished!"

  # Call the original entrypoint script
  exec docker-php-entrypoint "$@"
}

main "$@"
