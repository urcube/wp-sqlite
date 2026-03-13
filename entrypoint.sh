#!/bin/sh
set -e

# 1. Sync the core files (non-destructive)
echo "Syncing WordPress core..."
cp -rn /usr/src/wordpress/. /var/www/html/

# 2. FORCE the SQLite integration files
# This ensures that even if the host volume is old, the DB driver is current
echo "Updating SQLite integration..."
mkdir -p /var/www/html/wp-content/mu-plugins/
cp -rf /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration /var/www/html/wp-content/mu-plugins/
cp -f /usr/src/wordpress/wp-content/db.php /var/www/html/wp-content/db.php

# 3. Ensure the database directory exists and is writeable
mkdir -p /var/www/html/wp-content/database

# 4. Permissions
echo "Setting permissions..."
chown -R 82:82 /var/www/html

echo "Starting PHP-FPM..."
exec "$@"