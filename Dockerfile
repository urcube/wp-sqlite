# STAGE 1: Fetch
FROM alpine:latest AS fetcher
ARG WP_VERSION=latest

RUN apk add --no-cache curl tar unzip
RUN if [ "$WP_VERSION" = "latest" ]; then \
      curl -fL https://wordpress.org/latest.tar.gz | tar -xz -C /tmp; \
    else \
      curl -fL https://wordpress.org/wordpress-${WP_VERSION}.tar.gz | tar -xz -C /tmp; \
    fi
RUN curl -fL https://downloads.wordpress.org/plugin/sqlite-database-integration.zip -o /tmp/plugin.zip && \
    unzip /tmp/plugin.zip -d /tmp/

# STAGE 2: Builder
FROM php:8.4-fpm-alpine AS builder
RUN apk add --no-cache libpng-dev libjpeg-turbo-dev libwebp-dev libzip-dev sqlite-dev $PHPIZE_DEPS \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd zip opcache

# STAGE 3: Final Image
FROM php:8.4-fpm-alpine
RUN apk add --no-cache libpng libjpeg-turbo libwebp libzip sqlite-libs 

COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions 
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d 

WORKDIR /var/www/html 

# 1. Copy WordPress Core
COPY --from=fetcher --chown=82:82 /tmp/wordpress /usr/src/wordpress 

# 2. Setup SQLite Plugin
RUN mkdir -p /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration 
COPY --from=fetcher --chown=82:82 /tmp/sqlite-database-integration/ /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration/ 

# 3. Create the SQLite Drop-in (ADD HERE)
RUN cp /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration/db.copy /usr/src/wordpress/wp-content/db.php && \
    sed -i "s|{SQLITE_IMPLEMENTATION_FOLDER_PATH}|/var/www/html/wp-content/mu-plugins/sqlite-database-integration|g" /usr/src/wordpress/wp-content/db.php 

# 4. Setup the Database directory
RUN mkdir -p /usr/src/wordpress/wp-content/database && \
    chown -R 82:82 /usr/src/wordpress/wp-content 

# 5. Provide the wp-config.php template
COPY wp-config.php /usr/src/wordpress/wp-config.php
RUN chown 82:82 /usr/src/wordpress/wp-config.php

# 6. Entrypoint Setup
# Copy the script from your repo into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to run the script and default to php-fpm
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]