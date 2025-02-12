ifndef VERBOSE
.SILENT:
endif

.DEFAULT_GOAL := help

log_error = (>&2 echo "\x1B[31m>> Error:$1\x1B[39m\n"; $(MAKE) help; exit 1)

.PHONY: help
help:
	@echo "Usage: make (provisioner) [os] [version] [command]"
	@echo "\n"
	@echo "Examples:"
	@echo "  make ubuntu 2004 up"
	@echo "  make ubuntu 2004 ssh"
	@echo "  make ubuntu 2004 suspend"
	@echo "  make windows server-2019 destroy"
	@echo "  make windows server-2019 rdp"
	@echo "  make pooler windows server-2022 up"
	@echo " "
	@echo " provisioner (optional) pooler | vagrant"
	@echo " defaults to vagrant"
	@echo "\n"


# Operating System Config

# ============= Windows ============= #
.PHONY: windows
windows:
	$(eval PLAT=windows)
ifneq (,$(findstring up,$(MAKECMDGOALS)))
	/opt/puppetlabs/bin/bolt module install --project ./windows/bootstrap
endif

server-2012R2:
	$(eval VERSION=server-2012R2)

server-2016:
	$(eval VERSION=server-2016)

server-2019:
	$(eval VERSION=server-2019)

server-2022:
	$(eval VERSION=server-2022)

# ============= Ubuntu ============= #
.PHONY: ubuntu
ubuntu:
	$(eval PLAT=ubuntu)

2004:
	$(eval VERSION=2004)

# ============= Vagrant ============= #

.PHONY: up
up:
	@[ "${PROVISIONER}" ] 
	@[ "${PLAT}" ] || $(call log_error, "Operating System is not defined")
	@[ "${VERSION}" ] || $(call log_error, "Version is not defined")

	if [ "${PROVISIONER}" = "pooler" ]; then \
		${PLAT}/${PROVISIONER}/provision.sh ${VERSION}; \
	else \
		@VAGRANT_CWD=${PLAT}/${VERSION} vagrant up; \
	fi

.PHONY: destroy
destroy:
	@[ "${PLAT}" ] || $(call log_error, "Operating System is not defined")
	@[ "${VERSION}" ] || $(call log_error, "Version is not defined")

	@VAGRANT_CWD=${PLAT}/${VERSION} vagrant destroy -f 

.PHONY: ssh
ssh:
	@[ "${PROVISIONER}" ] 
	@[ "${PLAT}" ] || $(call log_error, "Operating System is not defined")
	@[ "${VERSION}" ] || $(call log_error, "Version is not defined")

	if [ "${PROVISIONER}" = "pooler" ]; then \
		${PLAT}/${PROVISIONER}/ssh.sh ${VERSION}; \
	else \
		@VAGRANT_CWD=${PLAT}/${VERSION} vagrant ssh \
	fi

.PHONY: rdp
rdp:
	@[ "${PROVISIONER}" ] 
	@[ "${PLAT}" ] || $(call log_error, "Operating System is not defined")
	@[ "${VERSION}" ] || $(call log_error, "Version is not defined")

	if [ "${PROVISIONER}" = "pooler" ]; then \
		${PLAT}/${PROVISIONER}/rdp.sh ${VERSION}; \
	else \
		@VAGRANT_CWD=${PLAT}/${VERSION} vagrant rdp \
	fi

.PHONY: suspend
suspend:
	@[ "${PROVISIONER}" ] 
	@[ "${PLAT}" ] || $(call log_error, "Operating System is not defined")
	@[ "${VERSION}" ] || $(call log_error, "Version is not defined")

	@VAGRANT_CWD=${PLAT}/${VERSION} vagrant suspend


# ============= VMPooler ============= #
.PHONY: pooler
pooler:
	$(eval PROVISIONER=pooler)

