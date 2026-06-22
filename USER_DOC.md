# User Documentation

## Services provided

This stack provides a WordPress website accessible via HTTPS, backed by a MariaDB database. The infrastructure consists of three containers:

- **nginx** — the only entry point, handles HTTPS on port 443
- **wordpress** — the WordPress application with PHP-FPM
- **mariadb** — the database server

## Start and stop the project

Start all services:
```bash
make
```

Stop all services (data is preserved):
```bash
make down
```

Stop and remove all data (full reset):
```bash
make clean
```

## Access the website

Open a browser and navigate to:

https://demane.42.fr

Accept the self-signed certificate warning to proceed.

To access the WordPress administration panel:

https://demane.42.fr/wp-admin

## Credentials

All credentials are stored in the `secrets/` directory at the root of the project:

- `secrets/db_password.txt` — WordPress database user password
- `secrets/db_root_password.txt` — MariaDB root password
- `secrets/credentials.txt` — WordPress admin login and password

Environment variables (domain name, database name, usernames) are stored in `srcs/.env`.

## Check that services are running

```bash
docker ps
```

All three containers (nginx, wordpress, mariadb) should show status `Up`.

To check logs for a specific service:
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```
