MOCK_SERVER = mock_server
MOCK_TESTER = mock_tester

.DEFAULT_GOAL := help
.PHONY: help
help: ## Print help
	@echo "------------------------------------------------------------------------"
	@echo "MockServer Robot Framework Library"
	@echo "------------------------------------------------------------------------"
	@awk -F ":.*##" '/:.*##/ && ! /\t/ {printf "\033[36m%-25s\033[0m%s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: setup
setup: ## Setup dev environment
	sudo pip install -r requirements.txt

.PHONY: server/run
server/run: ## Run mock server
	ROBOT_ARGS=$(ROBOT_ARGS) docker-compose up -d $(MOCK_SERVER)

.PHONY: server/stop
server/stop: ## Stop mock server
	docker-compose down

.PHONY: tester/test
tester/test: ## Run integration tests
	docker-compose up $(COMPOSE_ARGS) $(MOCK_TESTER)

.PHONY: lint
lint: ## Run static code analysis
	flake8

.PHONY: release
release: ## Release package to PyPI
	twine upload dist/*
