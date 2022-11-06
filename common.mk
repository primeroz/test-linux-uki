#common variables shared accross Makefiles
SHELL := bash -eo pipefail

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

ENVIRONMENT ?= test1

ifndef ENVIRONMENT
$(error the variable ENVIRONMENT is not defined, run using `ENVIRONMENT=kind make deploy-all')
endif

#SECRET_SHOW := az keyvault secret show --vault-name $(AZURE_KEY_VAULT_NAME) --query 'value' -o tsv --name
