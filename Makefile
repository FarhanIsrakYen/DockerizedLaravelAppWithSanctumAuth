.PHONY: help ps fresh build start stop destroy tests tests-html migrate \
	migrate-fresh migrate-tests-fresh install-xdebug create-env

CONTAINER_PHP=app
VOLUME_DATABASE=db
REQUEST_NAME=default
CONTROLLER_NAME=default
MODEL_NAME=default

build: create-env ## Build all containers.
	@docker compose build --no-cache

cache:
	docker exec -it ${CONTAINER_PHP} php artisan optimize

controller: ## Create controller
	docker exec -it ${CONTAINER_PHP} php artisan make:controller ${CONTROLLER_NAME}

create-env: ## Copy .env.example to .env
	@if [ ! -f ".env" ]; then \
		echo "Creating .env file."; \
		cp .env.example .env; \
	fi

destroy: create-env down ## Destroy all containers.
	@docker compose down
	@if [ "$(shell docker volume ls --filter name=${VOLUME_DATABASE} --format {{.Name}})" ]; then \
		docker volume rm ${VOLUME_DATABASE}; \
	fi

down: create-env ## Stop all containers.
	@docker compose down

fresh: down destroy build up ## Destroy & recreate all containers.

generate-key:
	docker exec ${CONTAINER_PHP} php artisan key:generate

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install-xdebug: ## Install xdebug locally.
	docker exec ${CONTAINER_PHP} pecl install xdebug
	docker exec ${CONTAINER_PHP} /usr/local/bin/docker-php-ext-enable xdebug.so

migrate: ## Run migration files.
	docker exec ${CONTAINER_PHP} php artisan migrate

migrate-fresh: ## Clear database and run all migrations.
	docker exec ${CONTAINER_PHP} php artisan migrate:fresh

model: ## Create model with migration and controller
	docker exec -it ${CONTAINER_PHP} php artisan make:model ${MODEL_NAME} --mc

ps: ## Show containers.
	@docker compose ps

request: ## Create request file
	docker exec -it ${CONTAINER_PHP} php artisan make:request ${REQUEST_NAME}

ssh:
	docker exec -it ${CONTAINER_PHP} sh

tests:
	docker exec ${CONTAINER_PHP} ./vendor/bin/phpunit

tests-html: ## Run tests + generate coverage.
	docker exec ${CONTAINER_PHP} php -d zend_extension=xdebug.so -d xdebug.mode=coverage ./vendor/bin/phpunit --coverage-html reports

up: create-env generate-key ## Start all containers.
	@docker compose up --force-recreate -d
