# thomashaus.github.io: plain static HTML served by GitHub Pages. No dependencies, no build.
.DEFAULT_GOAL := help
.PHONY: help setup dev install

PORT ?= 8000
PROD_URL ?= https://www.tomhaus.io
# Allocate a terminal only when there is one, so Ctrl-C stops the container.
TTY := $(shell [ -t 0 ] && echo -it)

help: ## List targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-8s %s\n", $$1, $$2}'

setup: ## First-time dev setup: nothing to install, only checks Docker for 'make dev'
	@command -v docker >/dev/null || { echo "docker is needed for 'make dev'"; exit 1; }
	@echo "nothing to install; run 'make dev'"

dev: ## Run locally in Docker (nginx) on http://localhost:$(PORT) (Ctrl-C stops)
	docker run --rm $(TTY) --name thomashaus-github-io-dev -p 127.0.0.1:$(PORT):80 \
	  -v "$(CURDIR):/usr/share/nginx/html:ro" nginx:1.27-alpine

# There is no production server to install on: GitHub Pages publishes every push to main.
install: ## Production is published by GitHub Pages on push to main; this checks $(PROD_URL)
	git fetch origin main
	@echo "GitHub Pages publishes origin/main ($$(git rev-parse --short origin/main)) on its own; checking $(PROD_URL)"
	curl -fsSIL -o /dev/null -w '%{http_code} %{url_effective}\n' $(PROD_URL)
