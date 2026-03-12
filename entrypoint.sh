#!/bin/sh
set -e

# Sync WordPress core files from the internal source to the live volume
# We use -a to preserve permissions and -u to only update older files
echo "Syncing WordPress core..."
cp -a /usr/src/wordpress/. /var/www/html/

# Ensure the webserver (user 82/www-data) owns the files
echo "Setting permissions..."
chown -R 82:82 /var/www/html

# Hand off execution to PHP-FPM
echo "Starting PHP-FPM..."
exec "$@"