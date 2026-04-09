#!/bin/sh
set -e

# 1. Initialize the Named Volume
# This only runs if the volume is empty (e.g., a new dev setup or server migration)
if [ ! -e /var/www/html/index.php ]; then
    echo "Initializing WordPress core in volume..."
    cp -rn /usr/src/wordpress/. /var/www/html/
fi

# 2. Sync SQLite Driver
# We keep this outside the 'if' to ensure that if you update your 
# Docker image, the SQLite logic in the volume updates too.
echo "Syncing SQLite driver..."
mkdir -p /var/www/html/wp-content/mu-plugins/
cp -rf /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration /var/www/html/wp-content/mu-plugins/
cp -f /usr/src/wordpress/wp-content/db.php /var/www/html/wp-content/db.php

# 3. Handle the Database Bind Mount
# This is the ONLY folder that needs strict write permissions for Search to work
echo "Setting up database permissions..."
mkdir -p /var/www/html/wp-content/database
chown -R 82:82 /var/www/html/wp-content/database

# 4. Cleanup/Start
echo "WordPress is ready. Starting PHP-FPM..."
exec "$@"