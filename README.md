# WordPress SQLite
    
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/urcube/wp-sqlite/docker-publish.yml?branch=main&label=build&style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/urcb/wp-sqlite?style=flat-square)
![Docker Image Version](https://img.shields.io/docker/v/urcb/wp-sqlite/latest?label=wordpress&style=flat-square&logo=wordpress)
![License](https://img.shields.io/github/license/urcube/wp-sqlite?style=flat-square)

Base Builder for Lightweight, MySQL-Free WordPress

This repository is strictly used for automatically building the `wp-light` (`urcb/wp-sqlite`) Docker image. It is not intended for direct use or standalone deployment. The resulting image provides a professional-grade, stateless environment running entirely on SQLite, which can then be utilized via Docker Compose for low-overhead hosting and rapid local development.


## Key Features

**Zero-Database Overhead**: Uses the Official SQLite Database Integration; no MySQL required.  
**Ultra-Small Footprint**: Built on Alpine Linux with a 3-stage build process to keep the final image as slim as possible.  
**PHP 8.4 Optimized**: Pre-configured with essential extensions including GD, Zip, and Opcache.  
**Stateless Architecture**: WordPress core files are stored in a read-only source (/usr/src/wordpress) and synced to the web root on boot ensuring consistent deployments.  
**Pre-Configured Base**: Pre-packages the necessary SQLite `db.php` drop-in and establishes the necessary file structure, outputting an optimized image ready for Docker Compose integration.  

## Usage

This project auto-builds the `urcb/wp-sqlite` image. To deploy the resulting lightweight instance, use the provided [docker-compose.yml](cci:7://file:///home/j0e/Documents/wordpress/wp-sqlite/docker-compose.yml:0:0-0:0) and [nginx.conf](cci:7://file:///home/j0e/Documents/wordpress/wp-sqlite/nginx.conf:0:0-0:0) included in this repository.

Simply start the environment with Docker Compose:
```bash
docker-compose up -d
```

## How it Works

The build process uses a sophisticated 3-Stage Pipeline:

**Fetcher**: Downloads the latest WordPress core and the SQLite integration plugin.  
**Builder**: Compiles PHP extensions using Alpine build tools, which are then discarded to save space.  
**Final**: Assembles the pre-compiled extensions, configures the SQLite db.php pathing via sed, and generates a minimal wp-config.php.  

## Project Structure

- **Dockerfile**: The multi-stage build instructions.
- **wp-config.php**: A minimal, pre-configured WordPress setup file optimized for this SQLite environment.
- **/entrypoint.sh**: Handles the synchronization of WordPress files to the live volume and sets proper permissions (82:82 for `www-data`).


- **docker-compose.yml**: A ready-to-use Compose file that spins up the pre-built `urcb/wp-sqlite:latest` container alongside an Nginx web server.
- **nginx.conf**: The Nginx configuration used by the docker-compose setup to proxy requests to PHP-FPM.
