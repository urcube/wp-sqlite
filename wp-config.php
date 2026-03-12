<?php
$table_prefix = 'wp_';

/** Essential SQLite Constants */
define( 'DB_TYPE', 'sqlite' );
define( 'USE_NHP_SQLITE', true );

/** Production Security Settings */
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'DISALLOW_FILE_EDIT', true );

/** * Security Salts - Use getenv() so they can be set in docker-compose.yml 
 * or provide defaults for local testing.
 */
define('AUTH_KEY',         getenv('WP_AUTH_KEY')         ?: 'put-random-string-here');
define('SECURE_AUTH_KEY',  getenv('WP_SECURE_AUTH_KEY')  ?: 'put-random-string-here');
define('LOGGED_IN_KEY',    getenv('WP_LOGGED_IN_KEY')    ?: 'put-random-string-here');
define('NONCE_KEY',        getenv('WP_NONCE_KEY')        ?: 'put-random-string-here');
define('AUTH_SALT',        getenv('WP_AUTH_SALT')        ?: 'put-random-string-here');
define('SECURE_AUTH_SALT', getenv('WP_SECURE_AUTH_SALT') ?: 'put-random-string-here');
define('LOGGED_IN_SALT',   getenv('WP_LOGGED_IN_SALT')   ?: 'put-random-string-here');
define('NONCE_SALT',       getenv('WP_NONCE_SALT')       ?: 'put-random-string-here');

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';