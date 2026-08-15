SHELL := /bin/bash

UV ?= uv
UV_CACHE_DIR ?= /tmp/schwinn-uv-cache
UV_RUN = UV_CACHE_DIR="$(UV_CACHE_DIR)" $(UV) run --no-sync
RUFF_RUN = RUFF_CACHE_DIR=/tmp/schwinn-ruff-cache $(UV_RUN) ruff
PYTEST_RUN = $(UV_RUN) pytest -p no:cacheprovider
IMAGE ?= schwinn:latest
PLATFORM ?= linux/amd64
PORT ?= 8080
DOCKER_RUN_PORT ?= $(PORT)
DATA_DIR ?= /app/data
DOCKER_TEST_PORT ?= 18080
DOCKER_TEST_NAME ?= schwinn-ui-test

.PHONY: check format lint test coverage security deps-check requirements-check npm-lock-check install lock run build docker-build docker-run docker-ui-test local-test precommit clean

install:
	$(UV) sync

lock:
	UV_CACHE_DIR="$(UV_CACHE_DIR)" $(UV) lock

check: format lint test coverage security deps-check

format:
	$(RUFF_RUN) format --check .

lint:
	$(RUFF_RUN) check .

test:
	$(PYTEST_RUN) -q

coverage:
	COVERAGE_FILE=/tmp/schwinn-coverage $(PYTEST_RUN) --cov=app --cov-report=term-missing --cov-fail-under=95

security:
	$(UV_RUN) pip-audit
	$(UV_RUN) bandit -r app -x app/logs

deps-check: requirements-check npm-lock-check

requirements-check:
	@set -euo pipefail; \
	diff -u <(grep -v '^#' requirements.txt) <(UV_CACHE_DIR="$(UV_CACHE_DIR)" $(UV) export --frozen --no-dev --format requirements-txt --no-hashes | grep -v '^#')

npm-lock-check:
	npm ci --ignore-scripts --dry-run

local-test: test coverage security docker-ui-test

git-hooks:
	@git config core.hooksPath .githooks
	@echo "Git hooks path configured to .githooks"

precommit: local-test

run:
	$(UV) run uvicorn app.app:app --host 0.0.0.0 --port $(PORT)

build: docker-build

docker-build:
	docker build --platform $(PLATFORM) -t $(IMAGE) .

docker-run: docker-build
	docker run --rm \
		-e PORT=$(PORT) \
		-e DATA_DIR=$(DATA_DIR) \
		-p $(DOCKER_RUN_PORT):$(PORT) \
		-v "$(PWD)/app/data:$(DATA_DIR)" \
		--platform $(PLATFORM) \
		$(IMAGE)

docker-ui-test: docker-build
	npm ci
	npx playwright install chromium
	docker rm -f $(DOCKER_TEST_NAME) >/dev/null 2>&1 || true; \
	docker run --rm -d \
		--name $(DOCKER_TEST_NAME) \
		-e PORT=$(PORT) \
		-e DATA_DIR=$(DATA_DIR) \
		-p $(DOCKER_TEST_PORT):$(PORT) \
		--platform $(PLATFORM) \
		$(IMAGE); \
	trap 'docker rm -f $(DOCKER_TEST_NAME) >/dev/null 2>&1 || true' EXIT; \
	BASE_URL=http://127.0.0.1:$(DOCKER_TEST_PORT) \
	CONTAINER_NAME=$(DOCKER_TEST_NAME) \
	npx playwright test tests/docker-ui.spec.mjs --browser=chromium

clean:
	rm -rf .pytest_cache .venv 
