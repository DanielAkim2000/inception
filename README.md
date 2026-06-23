*This project has been created as part of the 42 curriculum by demane.*

## Description

Inception is a system administration project that consists of setting up a small infrastructure using Docker. The goal is to virtualize several services inside a personal virtual machine using docker compose, with each service running in its own dedicated container built from scratch.

The stack includes:
- NGINX as the sole entry point (port 443, TLSv1.2/1.3)
- WordPress + PHP-FPM as the web application
- MariaDB as the database

### Docker vs Virtual Machines

A virtual machine emulates an entire operating system with its own kernel, requiring significant resources. Docker containers share the host kernel and isolate only the application layer, making them much lighter and faster to start. However, VMs offer stronger isolation since each has its own OS.

### Secrets vs Environment Variables

Environment variables are stored in plain text and can be exposed through logs or process inspection. Docker secrets are mounted as files inside containers at `/run/secrets/` and are never exposed in environment variables or image layers, making them more secure for sensitive data like passwords.

### Docker Network vs Host Network

Host network mode makes the container share the host's network stack directly, removing isolation. A Docker bridge network creates an isolated virtual network where containers communicate using their service names as hostnames, which is more secure and portable.

### Docker Volumes vs Bind Mounts

Bind mounts directly map a host path to a container path, making them dependent on the host's directory structure. Named volumes are managed by Docker, are more portable, and are the recommended approach for persistent data. This project uses named volumes stored in `/home/demane/data/`.

## Instructions

### Prerequisites

- Docker and docker compose installed
- A virtual machine running Debian bookworm
- Add `127.0.0.1 demane.42.fr` to `/etc/hosts`
- Create the data directories: `mkdir -p /home/demane/data/mariadb /home/demane/data/wordpress`
- Fill in the secrets files in `secrets/`

### Run the project

```bash
make        # build and start all containers
make down   # stop all containers
make clean  # stop and remove volumes
make fclean # full cleanup including images
make re     # full rebuild
```

Access the site at `https://demane.42.fr` (accept the self-signed certificate warning).

## Resources

- [Docker documentation](https://docs.docker.com)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [PHP-FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)

### AI usage

AI was used in this project to assist with debugging shell scripts (init.sh, wp-setup.sh), understanding Docker networking concepts, and generating configuration file templates. All generated content was reviewed, tested, and adapted to fit the specific constraints of the project.

## Bonus services

- **Adminer** — database management UI accessible at `https://demane.42.fr:8080`
- **Static website** — portfolio page accessible at `http://demane.42.fr:8081`
- **Redis cache** — object cache for WordPress, improves performance
- **FTP server** — vsftpd pointing to the WordPress volume, accessible on port 21
- **Netdata** — real-time system and container monitoring at `http://demane.42.fr:19999`
