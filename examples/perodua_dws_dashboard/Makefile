# Perodua DWS Dashboard Makefile

.PHONY: help install clean run test build analyze

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	flutter pub get

clean: ## Clean build artifacts
	flutter clean
	flutter pub get

run: ## Run the application
	flutter run

test: ## Run tests
	flutter test

build: ## Build the application
	flutter build web

analyze: ## Analyze the code
	flutter analyze

format: ## Format the code
	dart format lib/ test/

check: analyze test ## Run all checks (analyze + test)

dev: ## Run in development mode with hot reload
	flutter run --hot

release: ## Build for release
	flutter build web --release

.DEFAULT_GOAL := help