MOCK_SERVER = mock_server
MOCK_TESTER = mock_tester

VERSION ?= $(shell grep -o "\([0-9]\+\.\)\+[0-9]\+" src/MockServerLibrary/version.py)

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
	docker-compose up --build --force-recreate $(MOCK_TESTER)

.PHONY: lint
lint: ## Run static code analysis
	flake8 src

.PHONY: clean
clean: ## Clean dist
	rm -rf dist MANIFEST

.PHONY: release
release: clean ## Release package to PyPI
	python setup.py sdist
	twine upload dist/robotframework-mockserver-$(VERSION).tar.gz

.PHONY: version/tag
version/tag: ## Tag HEAD with new version tag
	git tag -a $(VERSION) -m "$(VERSION)"
