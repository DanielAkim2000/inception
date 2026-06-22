NAME = inception

all: up

build:
	@mkdir -p /home/demane/data/mariadb /home/demane/data/wordpress
	@docker compose -f srcs/docker-compose.yml build

up:
	@mkdir -p /home/demane/data/mariadb /home/demane/data/wordpress
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@docker compose -f srcs/docker-compose.yml down

clean: down
	@docker compose -f srcs/docker-compose.yml down -v
	@sudo rm -rf /home/demane/data/mariadb/* /home/demane/data/wordpress/*

fclean: clean
	@docker system prune -af

re: fclean up

.PHONY: all build up down clean fclean re
