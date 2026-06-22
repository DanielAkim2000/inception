# Developer Documentation

## Prerequisites

- Debian bookworm virtual machine
- Docker and docker compose installed
- User added to the docker group: `sudo usermod -aG docker $USER`

## Environment setup

### 1. Clone the repository

```bash
git clone <repo_url>
cd <repo_name>
```

### 2. Configure /etc/hosts

```bash
echo "127.0.0.1 demane.42.fr" | sudo tee -a /etc/hosts
```

### 3. Create data directories

```bash
mkdir -p /home/demane/data/mariadb /home/demane/data/wordpress
```

### 4. Fill in the secrets files

```bash
echo "your_db_password" > secrets/db_password.txt
echo "your_root_password" > secrets/db_root_password.txt
echo "admin_user:admin_password" > secrets/credentials.txt
```

### 5. Configure the .env file

Edit `srcs/.env` and fill in all variables:

```env
DOMAIN_NAME=demane.42.fr
MYSQL_USER=demane
MYSQL_PASSWORD=your_db_password
MYSQL_DATABASE=demanedb
MYSQL_ROOT_PASSWORD=your_root_password
WP_ADMIN=demane_ad
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=your@email.com
WP_USER=demane_us
WP_USER_PASSWORD=your_user_password
WP_USER_EMAIL=your@email.com
```

## Build and launch

Build and start all containers:
```bash
make
```

Build only (without starting):
```bash
make build
```

Start without rebuilding:
```bash
make up
```

## Useful Docker commands

Check running containers:
```bash
docker ps
```

View logs in real time:
```bash
docker logs -f mariadb
docker logs -f wordpress
docker logs -f nginx
```

Enter a container shell:
```bash
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash
```

Connect to the database:
```bash
docker exec -it mariadb mariadb -u root -p
```

## Project data

Persistent data is stored on the host machine at:

- `/home/demane/data/mariadb/` — MariaDB database files
- `/home/demane/data/wordpress/` — WordPress files and uploads

These directories are mounted as named Docker volumes. Data persists across `make down` and `make up` cycles. To fully reset, use `make clean` which removes both volumes and data directories.

## Container management

Stop all containers:
```bash
make down
```

Stop and remove volumes and data:
```bash
make clean
```

Full cleanup including Docker images:
```bash
make fclean
```

Full rebuild from scratch:
```bash
make re
```
