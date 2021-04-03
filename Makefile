# ---------------------------------------------------------------------------

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DCCOMMAND = docker-compose


# ---------------------------------------------------------------------------



help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help


img: ## Build stack-specific images. Run whenever you make changes to the Dockerfiles
	@$(DCCOMMAND) build
.PHONY: img


dev: ## Runs local development environment making sure we are using the right Kubernetes context
	@$(DCCOMMAND) down --remove-orphans
	@$(DCCOMMAND) up -d --remove-orphans $(only)
	@$(DCCOMMAND) logs -f
.PHONY: dev


logs: ## Watch stack logs
	@$(DCCOMMAND) logs -f
.PHONY: logs


watch: ## Watch stack containers
	@watch docker-compose ps
.PHONY: watch


up: ## Start stack for development (same as make dev)
	@make dev
.PHONY: up


down: ## shut down stack
	@$(DCCOMMAND) down --remove-orphans
.PHONY: down


reload: ##Reload nginx config
	@$(DCCOMMAND) stop nginx
	@$(DCCOMMAND) start nginx
.PHONY: reload
