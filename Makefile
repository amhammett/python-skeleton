.PHONEY = deploy help install isort json-lint pip_packages pytest run test venv watch

# pathing
ifeq ($(OS),Windows_NT)
    python_path := $(shell /F where python3)
    venv_flake8_path := venv/Scripts/flake8
    venv_isort_path := venv/Scripts/isort
    venv_jsonlint_path := venv/Scripts/jsonlint
    venv_pip_path := venv/Scripts/pip
    venv_pytest_path := venv/Scripts/pytest
    venv_python_path := venv/Scripts/python
    venv_watchmedo_path := venv/Scripts/watchmedo
    virtualenv_path := ${python_path} -m virtualenv
else
    python_path := $(shell which python3)
    venv_flake8_path := ./venv/bin/flake8
    venv_isort_path := ./venv/bin/isort
    venv_jsonlint_path := ./venv/bin/jsonlint
    venv_pip_path := ./venv/bin/pip
    venv_pytest_path := ./venv/bin/pytest
    venv_python_path := ./venv/bin/python
    venv_watchmedo_path := ./venv/bin/watchmedo
    virtualenv_path := virtualenv
endif

help: ## this help text
	@echo 'Available targets'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# env
install: | venv pip_packages ## install all the things

venv: ## setup virtualenv
	pip install virtualenv
	$(virtualenv_path) venv --python $(python_path)

pip_packages: ## install yarn packages
	$(venv_pip_path) install pip -I || $(venv_pip_alt) install pip -I
	$(venv_pip_path) install --exists-action w -r requirements.txt

# dev
command := make test || true

# dev
command := make test
pattern := '*.py'
watch: ## watch file-system changes to trigger a command
	$(venv_watchmedo_path) shell-command --patterns="${pattern}" --recursive --command="${command}" .

# run
run: ## run the service
	@echo run. <update the Makefile>

deploy: ## deploy the service
	@echo deploy. <update the Makefile>

# tests
test: | json-lint isort flake8 pytest ## test all the things

json-lint: ## json linter
	$(venv_jsonlint_path) data/*.json

isort: ## validate import order
	$(venv_isort_path) --skip .venv --skip venv --recursive --check-only --quiet src/ tests/

flake8: ## python linter
	$(venv_flake8_path) src/ tests/

pytest: ## unit and integration tests
	$(venv_pytest_path) --cov=src/ --cov-branch tests --verbose --capture=no
