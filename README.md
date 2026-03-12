# WordPress SQLite
    
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/urcube/wp-sqlite/docker-publish.yml?branch=main&label=build&style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/urcb/wp-sqlite?style=flat-square)
![Docker Image Version](https://img.shields.io/docker/v/urcb/wp-sqlite/latest?label=wordpress&style=flat-square&logo=wordpress)
![License](https://img.shields.io/github/license/urcube/wp-sqlite?style=flat-square)

Stateless, High-Performance, MySQL-Free WordPress

This repository contains a professional-grade Dockerized WordPress environment that runs entirely without a separate database container. By leveraging SQLite, it eliminates the RAM and CPU overhead of MySQL/MariaDB, making it the perfect solution for edge computing, low-cost VPS hosting (like $5/mo tiers), and rapid local development.


## Key Features

**Zero-Database Overhead**: Uses the Official SQLite Database Integration; no MySQL required.
**Ultra-Small Footprint**: Built on Alpine Linux with a 3-stage build process to keep the final image as slim as possible.
**PHP 8.4 Optimized**: Pre-configured with essential extensions including GD, Zip, and Opcache.
**Stateless Architecture**: WordPress core files are stored in a read-only source (/usr/src/wordpress) and synced to the web root on boot, ensuring consistent deployments.
**Self-Configuring**: Automatically generates the required db.php drop-in and a lightweight wp-config.php during the build phase.

## Quick Start

1. Build the Image

```bash
docker build -t wp-sqlite-lite .
```

2. Run the Container

To ensure your plugins, themes, and database file are saved when the container restarts, mount a volume to the wp-content directory:

```bash
docker run -d \
  -p 8080:9000 \
  -v wp_data:/var/www/html/wp-content \
  --name my-tiny-wp \
  wp-sqlite-lite
```

## How it Works

The build process uses a sophisticated 3-Stage Pipeline:

**Fetcher**: Downloads the latest WordPress core and the SQLite integration plugin.
**Builder**: Compiles PHP extensions using Alpine build tools, which are then discarded to save space.
**Final**: Assembles the pre-compiled extensions, configures the SQLite db.php pathing via sed, and generates a minimal wp-config.php.

## Project Structure

Dockerfile: The multi-stage build instructions.
/entrypoint.sh: Handles the synchronization of WordPress files to the live volume and sets proper permissions (82:82 for www-data).