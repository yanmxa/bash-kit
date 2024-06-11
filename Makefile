
CONTAINER_TOOL ?= $(shell command -v podman >/dev/null 2>&1 && echo podman || (command -v docker >/dev/null 2>&1 && echo docker))

echo-container-tool:
	@echo "Using container tool: $(CONTAINER_TOOL)"