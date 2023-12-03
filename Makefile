.PHONY: help ps fresh build up down destroy tests tests-html migrate \
	migrate-fresh migrate-tests-fresh install-xdebug env

CONTAINER_PHP=app
VOLUME_DATABASE=db
REQUEST_NAME=default
CONTROLLER_NAME=default
MODEL_NAME=default

build: env
	@docker compose up -d --build --remove-orphans && make migrate && make generate-key && make cache

cache:
	docker exec -it ${CONTAINER_PHP} php artisan optimize

controller:
	docker exec -it ${CONTAINER_PHP} php artisan make:controller ${CONTROLLER_NAME}

env:
	@if [ ! -f ".env" ]; then \
		echo "Creating .env file."; \
		cp .env.example .env; \
	fi

destroy: down
	@docker compose down
	@if [ "$(shell docker volume ls --filter name=${VOLUME_DATABASE} --format {{.Name}})" ]; then \
		docker volume rm ${VOLUME_DATABASE}; \
	fi

down: env
	@docker compose down

fresh: down destroy build up

generate-key:
	docker exec ${CONTAINER_PHP} php artisan key:generate

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install-xdebug:
	docker exec ${CONTAINER_PHP} pecl install xdebug
	docker exec ${CONTAINER_PHP} /usr/local/bin/docker-php-ext-enable xdebug.so

migrate:
	docker exec ${CONTAINER_PHP} php artisan migrate

migrate-fresh:
	docker exec ${CONTAINER_PHP} php artisan migrate:fresh

model:
	docker exec -it ${CONTAINER_PHP} php artisan make:model ${MODEL_NAME} --mc

ps:
	@docker compose ps

request:
	docker exec -it ${CONTAINER_PHP} php artisan make:request ${REQUEST_NAME}

show-model-details:
	docker exec -it ${CONTAINER_PHP} php artisan model:show ${MODEL_NAME}

ssh:
	docker exec -it ${CONTAINER_PHP} sh

tests:
	docker exec ${CONTAINER_PHP} ./vendor/bin/phpunit

tests-html:
	docker exec ${CONTAINER_PHP} php -d zend_extension=xdebug.so -d xdebug.mode=coverage ./vendor/bin/phpunit --coverage-html reports

up:
	@docker compose up -d --remove-orphans
