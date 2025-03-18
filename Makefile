.FEATURES: shortest-stem
# Makefile for stable-diffusion-webui.
#
# OVERRIDABLE VARIABLES:
#  - BASE_DIR: base directory for all files and directories. (default: Makefile dir)
#  - APP_PREFIX: prefix for all app names and container images. (default: sdwebui)
#  - OVERLAY_SUFFIX: suffix for overlay directories. (default: overlay)
#  - CONTAINER_IMAGE_NAME: name of the container image. (default: APP_PREFIX)
#  - CONTAINER_WORKDIR: working directory inside the container. (default: /home/app/workdir)
#  - GIT_CLONE_DIR: directory to clone the git repository to.
#  - GIT_CLONE_URL: URL of the git repository to clone.
#  - APP1_SUFFIX: suffix for the first app. (default: base)
#  - APP2_SUFFIX: suffix for the second app. (default: main)
#  - APP3_SUFFIX: suffix for the third app. (default: test)
#  - APP1_LOWERDIR: lowerdir for the first app. (default: GIT_CLONE_DIR)
#  - APP2_LOWERDIR: lowerdir for the second app. (default: APP1_MOUNT_POINT)
#  - APP3_LOWERDIR: lowerdir for the third app. (default: APP2_MOUNT_POINT)
#  - CONTAINER_PORT: port for coontainer image build. (default: 7860)
#  - APP1_PORT: port for the first app. (default: CONTAINER_PORT)
#  - APP2_PORT: port for the second app. (default: APP1_PORT + 1)
#  - APP3_PORT: port for the third app. (default: APP2_PORT + 1)
#  - CONTAINTER_TOOL: container tool to use. (default: podman docker)
#  - FUSE_OVERLAYFS: fuse-overlayfs tool to use. (default: fuse-overlayfs)
#
# CONVENTIONS:
#  - All constants are upper case.
#  - All variables taking parameters are lower case.

# Check that the version of make is 4.0 or later.
# Awk is more common than expr, skipping check if awk not found.
MIN_VERSION := 4.0
ifeq ($(shell which awk 2>&1 > /dev/null && echo true || echo false),true)
ifeq ($(shell awk -v n=$(MAKE_VERSION) -v m=$(MIN_VERSION) 'BEGIN {if (n < m) {exit 1} else {exit 0}}' && echo true || echo false),false)
$(error Your make version $(MAKE_VERSION) is too old. Please update to version $(MIN_VERSION) or later.)
endif
endif

# Function to ensure a tool is available from list of possible names.
# Aborts with error if none of the tools are found.
#
#   Arguments:
#
#     1: Variable name to store the tool binary path.
#
#     2: Space separated preference list of possible tool names.
#        If the variable is already set, the list is ignored.
#
#   Example:
#      $(call require_tool,CONTAINER_TOOL,podman docker)
#      $(shell $(CONTAINER_TOOL) system info)
#
#   Note: this function cannot be used to find Awk for Make version check,
#         because the function relies on newer Make features itself.
define require_tool
$(eval $(1) ?= $(2))
$(eval require_tool_ORIG := $($(1)))
$(eval $(1) := $(firstword $(foreach BIN,$($(1)),$(shell which $(BIN) 2> /dev/null))))
$(if $($(1)),,$(error None of ($(reqire_tool_ORIG)) found. Please install one of them before running make.))
endef

$(call require_tool,CONTAINER_TOOL,podman docker)
$(call require_tool,FUSE_OVERLAYFS,fuse-overlayfs)

BASE_DIR ?= $(dir $(lastword $(MAKEFILE_LIST)))
BASE_DIR := $(abspath $(BASE_DIR))
APP_PREFIX ?= sdwebui
OVERLAY_SUFFIX ?= overlay
CONTAINER_IMAGE_NAME ?= $(APP_PREFIX)
CONTAINER_WORKDIR ?= /home/app/workdir
GIT_CLONE_DIR ?= $(APP_PREFIX)-repo
GIT_CLONE_DIR := $(BASE_DIR)/$(GIT_CLONE_DIR)
GIT_CLONE_URL ?= https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

APPS := APP1 APP2 APP3

APP1_SUFFIX ?= base
APP2_SUFFIX ?= main
APP3_SUFFIX ?= test

app_name = $(APP_PREFIX)-$($(1)_SUFFIX)
app_container_name = $(call app_name,$(1))
app_overlay_dir = $(BASE_DIR)/$(call app_name,$(1))-$(OVERLAY_SUFFIX)

lowerdir    = $(call app_overlay_dir,$(1))/lowerdir
upperdir    = $(call app_overlay_dir,$(1))/upperdir
workdir     = $(call app_overlay_dir,$(1))/workdir
mount_point = $(call app_overlay_dir,$(1))/mount

# Overlaying apps stack mapping.
APP1_LOWERDIR := $(GIT_CLONE_DIR)
APP2_LOWERDIR := $(call mount_point,APP1)
APP3_LOWERDIR := $(call mount_point,APP2)

app_lowerdir = $($(1)_LOWERDIR)

incr = $(shell echo $$(( $(1) + 1 )))

CONTAINER_PORT ?= 7860
APP1_PORT ?= $(CONTAINER_PORT)
APP2_PORT ?= $(call incr,$(APP1_PORT))
APP3_PORT ?= $(call incr,$(APP2_PORT))

app_port = $($(1)_PORT)

define app_rules

$(call app_name,$(1))-container-create: $(call mount_point,$(1)) container-image
	@if [ -z "$(shell $(CONTAINER_TOOL) ps -qaf name=$(call app_container_name,$(1)))" ]; then \
		echo "Creating container $(call app_container_name,$(1))..."; \
		$(CONTAINER_TOOL) create \
			--name $(call app_container_name,$(1)) \
			--volume $(call mount_point,$(1)):$(CONTAINER_WORKDIR) \
			--publish $(call app_port,$(1)):$(CONTAINER_PORT) \
			$(CONTAINER_IMAGE_NAME); \
	fi

$(call app_name,$(1))-container-start: $(call app_name,$(1))-container-create
	@if [ $(shell $(CONTAINER_TOOL) inspect -f '{{.State.Running}}' $(call app_container_name,$(1)) 2> /dev/null && echo true || echo false) = 'false' ]; then \
		echo "Starting container $(call app_container_name,$(1))..."; \
		$(CONTAINER_TOOL) start $(call app_container_name,$(1)); \
	fi

$(call app_name,$(1))-container-stop:
	@if [ $(shell $(CONTAINER_TOOL) inspect -f '{{.State.Running}}' $(call app_container_name,$(1)) 2> /dev/null && echo true || echo false) = 'true' ]; then \
		echo "Stopping container $(call app_container_name,$(1))..."; \
		$(CONTAINER_TOOL) stop $(call app_container_name,$(1)); \
	fi

$(call app_name,$(1))-container-remove: $(call app_name,$(1))-container-stop
	@if [ -n "$(shell $(CONTAINER_TOOL) ps -qaf name=$(call app_container_name,$(1)))" ]; then \
		echo "Removing container $(call app_container_name,$(1))..."; \
		$(CONTAINER_TOOL) rm $(call app_container_name,$(1)); \
	fi

$(call mount_point,$(1)): $(call app_overlay_dir,$(1))
	@if ! mountpoint -q $(call mount_point,$(1)); then \
		echo "Mounting $(call mount_point,$(1))..."; \
		$(FUSE_OVERLAYFS) -o lowerdir=$(call lowerdir,$(1)),upperdir=$(call upperdir,$(1)),workdir=$(call workdir,$(1)) $(call mount_point,$(1)); \
	fi

$(call app_overlay_dir,$(1)): $(call app_lowerdir,$(1)) FORCE
	@if ! mountpoint -q $(call mount_point,$(1)); then \
		echo "Creating overlay directory $(call app_overlay_dir,$(1))..."; \
		mkdir -p $(call upperdir,$(1)) $(call workdir,$(1)) $(call mount_point,$(1)); \
		ln -sf $(call app_lowerdir,$(1)) $(call lowerdir,$(1)); \
	fi

.PHONY: $(call app_name,$(1))
$(call app_name,$(1)): APP_NAME = $(call app_name,$(1))
$(call app_name,$(1)): $(call app_name,$(1))-container-start

endef # app_rules

default: $(call app_name,APP3)

$(GIT_CLONE_DIR): FORCE
	@if [ -d "$@" ]; then \
		git -C "$@" pull; \
	else \
		git clone --depth 1 $(GIT_CLONE_URL) "$@"; \
	fi

container-image: Containerfile FORCE
	$(CONTAINER_TOOL) build -t $(CONTAINER_IMAGE_NAME) -f Containerfile . \
		--build-arg CONTAINER_PORT=$(CONTAINER_PORT)

clean-repo: FORCE
	rm -rf $(GIT_CLONE_DIR)

clean-image: FORCE
	$(CONTAINER_TOOL) rmi $(CONTAINER_IMAGE_NAME)

$(foreach APP,$(APPS),$(eval $(call app_rules,$(APP))))

FORCE:
