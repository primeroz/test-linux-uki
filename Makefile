# https://raw.githubusercontent.com/FikaWorks/deploy-kubernetes-addons-makefile-example/master/Makefile
include common.mk
include env.$(ENVIRONMENT).mk

.DEFAULT_GOAL := help

.PHONY: all
all: create-efi create-disk-img

.PHONY: preflight
## Check requirements
preflight:
	@command -v objcopy >/dev/null 2>&1 || (echo "## Need objcopy command" && false)
	@command -v objdump >/dev/null 2>&1 || (echo "## Need objdump command" && false)
	@command -v genimage >/dev/null 2>&1 || (echo "## Need genimage command" && false)

.PHONY: create-disk-img
create-disk-img:
	@./scripts/genimage-efi.sh -c ./configs/genimage-efi.cfg


.PHONY: create-efi
## Create EFI Image using objcopy 

create-efi: preflight
	@echo "Creating EFI Image with kernel:$(KERNEL_FILE) initrd:$(INITRD_FILE)"
	@stub_line=$$(objdump -h "$(SYSTEMD_STUB_FILE)" | tail -2 | head -1) && \
	stub_size=0x$$(echo "$$stub_line" | awk '{print $$3}') && \
  stub_offs=0x$$(echo "$$stub_line" | awk '{print $$4}') && \
  osrel_offs=$$((stub_size + stub_offs)) && \
  cmdline_offs=$$((osrel_offs + $$(stat -c%s "$(OSRELEASE_FILE)"))) && \
  splash_offs=$$((cmdline_offs + $$(stat -c%s "$(CMDLINE_FILE)"))) && \
  linux_offs=$$((splash_offs + $$(stat -c%s "$(SPLASH_FILE)"))) && \
  initrd_offs=$$((linux_offs + $$(stat -c%s "$(KERNEL_FILE)"))) && \
  objcopy \
    --add-section .osrel="$(OSRELEASE_FILE)" --change-section-vma .osrel=$$(printf 0x%x $$osrel_offs) \
    --add-section .cmdline="$(CMDLINE_FILE)" --change-section-vma .cmdline=$$(printf 0x%x $$cmdline_offs) \
    --add-section .linux="$(KERNEL_FILE)" --change-section-vma .linux=$$(printf 0x%x $$linux_offs) \
    --add-section .initrd="$(INITRD_FILE)" --change-section-vma .initrd=$$(printf 0x%x $$initrd_offs) \
    --add-section .splash="$(SPLASH_FILE)" --change-section-vma .splash=$$(printf 0x%x $$splash_offs) \
    "$(SYSTEMD_STUB_FILE)" "$(OUTPUT_EFI_FILE)"



.PHONY: help
TARGET_MAX_CHAR_NUM=20
## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
