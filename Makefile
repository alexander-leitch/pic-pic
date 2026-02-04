.PHONY: help up down build logs shell api mysql redis clean

help: ## Show this help message
	@echo "Usage: make [command]"
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Start all services
	docker-compose up -d

down: ## Stop all services
	docker-compose down

build: ## Build all images
	docker-compose build

logs: ## Show logs for all services
	docker-compose logs -f

api: ## Show API logs
	docker-compose logs -f api

mysql: ## Show MySQL logs
	docker-compose logs -f mysql

redis: ## Show Redis logs
	docker-compose logs -f redis

shell: ## Open shell in API container
	docker-compose exec api bash

artisan: ## Run artisan command (usage: make artisan COMMAND="migrate")
	@if [ -z "$(COMMAND)" ]; then \
		echo "Usage: make artisan COMMAND=\"your-command\""; \
		exit 1; \
	fi
	docker-compose exec api php artisan $(COMMAND)

mysql-shell: ## Open MySQL shell
	docker-compose exec mysql mysql -u root -proot_password picpic

redis-shell: ## Open Redis shell
	docker-compose exec redis redis-cli

install: ## Install dependencies and setup
	@echo "Setting up PicPic development environment..."
	cp api/.env.docker api/.env
	docker-compose build
	docker-compose up -d mysql redis
	sleep 10
	docker-compose up -d api
	sleep 5
	docker-compose exec api composer install
	docker-compose exec api php artisan key:generate
	docker-compose exec api php artisan migrate
	@echo "Setup complete! API available at http://localhost:8000"
	@echo "PHPMyAdmin available at http://localhost:8080"
	@echo "MailHog available at http://localhost:8025"

clean: ## Clean up containers and volumes
	docker-compose down -v
	docker system prune -f

dev: ## Start development environment
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

prod: ## Start production environment
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build

status: ## Show status of all services
	docker-compose ps
